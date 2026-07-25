#!/usr/bin/env python3
"""Open two isolated Chrome windows and log each into a separate dev account.

For manually testing the two-player game flow without retyping credentials
in two browsers every time. Drives the real login form (no backend/frontend
auth bypass) - just automates what you'd otherwise click and type by hand.

Requires the two seeded accounts from db/seeds.rb (player1@dev.local /
player2@dev.local, password "password123") and the Flutter dev server
running (./dev.sh -> http://localhost:56569).

Usage:
    python3 scripts/two_player_login.py
    python3 scripts/two_player_login.py --url http://localhost:56569
"""

import argparse
import tempfile
import time
from selenium import webdriver
from selenium.common.exceptions import StaleElementReferenceException
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

DEFAULT_URL = "http://localhost:56569"
PLAYERS = [
    ("player1@dev.local", "password123"),
    ("player2@dev.local", "password123"),
]


def make_driver(profile_dir: str) -> webdriver.Chrome:
    options = webdriver.ChromeOptions()
    options.add_argument(f"--user-data-dir={profile_dir}")
    options.add_argument("--no-first-run")
    options.add_argument("--window-size=1280,900")
    # Keep the browser open after this script exits / the driver disconnects.
    options.add_experimental_option("detach", True)
    return webdriver.Chrome(options=options)


def enable_semantics(driver: webdriver.Chrome, wait: WebDriverWait) -> None:
    placeholder = wait.until(
        EC.presence_of_element_located((By.TAG_NAME, "flt-semantics-placeholder"))
    )
    # The placeholder is a 1x1px element behind the glass pane, so a real
    # (visually-targeted) click gets intercepted. Dispatch it via JS instead.
    driver.execute_script("arguments[0].click();", placeholder)


def js_click(driver: webdriver.Chrome, element) -> None:
    driver.execute_script("arguments[0].click();", element)


def type_into(driver: webdriver.Chrome, wait: WebDriverWait, selector: str, text: str):
    # Flutter web moves a single hidden backing <input> to whichever field is
    # focused; there's a brief handoff after .click() before it's actually
    # ready, so send_keys() right after can land before focus settles and
    # the keystrokes get dropped (field ends up empty). Verify and retry.
    # Even once the DOM value matches, Flutter's Dart-side TextEditingController
    # syncs from it asynchronously - give it a moment before moving on, or a
    # same-instant Enter keypress can submit before the controller catches up.
    for _ in range(4):
        field = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, selector)))
        field.click()
        field.send_keys(text)
        if field.get_attribute("value") == text:
            time.sleep(0.4)
            return field
    raise RuntimeError(f"Could not reliably type into {selector!r}")


def open_login_form(driver: webdriver.Chrome, wait: WebDriverWait) -> None:
    # The app opens on the Home screen; "Log In" lives in the drawer behind
    # the hamburger button (top-left, 44x44, no accessible label of its own).
    hamburger = wait.until(
        EC.presence_of_element_located((By.CSS_SELECTOR, '[role="button"]'))
    )
    js_click(driver, hamburger)

    def find_login_button(d):
        try:
            for e in d.find_elements(By.CSS_SELECTOR, '[role="button"]'):
                if e.text.strip() == "Log In":
                    return e
        except StaleElementReferenceException:
            pass
        return None

    login_button = wait.until(find_login_button)
    js_click(driver, login_button)


def log_in(driver: webdriver.Chrome, url: str, email: str, password: str) -> None:
    driver.get(url)
    # The first page load in a fresh profile pays a cold-start cost (Flutter
    # engine/canvaskit download+compile, plus the dev server may still be
    # compiling the bundle for the first request of the session) that later
    # loads don't - give it generous headroom rather than failing outright.
    wait = WebDriverWait(driver, 60)
    enable_semantics(driver, wait)
    open_login_form(driver, wait)

    # The login field's label is "Email or Username" (sign-up uses plain
    # "Email"), so match on a substring rather than the exact string - keeps
    # this working across label tweaks.
    type_into(driver, wait, '[aria-label*="Email"]', email)
    password_field = type_into(driver, wait, '[aria-label*="Password"]', password)
    password_field.send_keys(Keys.RETURN)

    # On success the app shows a toast and navigates back to Home; on failure
    # the account form stays put and shows an error. Wait for one or the other.
    def reached_home(d):
        try:
            return any(
                "Cards" in e.text and "Gangs" in e.text and "Game" in e.text
                for e in d.find_elements(By.CSS_SELECTOR, "[role='group']")
            )
        except StaleElementReferenceException:
            return False

    WebDriverWait(driver, 30).until(reached_home)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--url", default=DEFAULT_URL, help="Flutter web app URL")
    args = parser.parse_args()

    drivers = []
    for email, password in PLAYERS:
        profile_dir = tempfile.mkdtemp(prefix="carnevale-chrome-")
        driver = make_driver(profile_dir)
        drivers.append(driver)
        print(f"Logging in as {email} ...")
        attempts = 3
        for attempt in range(1, attempts + 1):
            try:
                log_in(driver, args.url, email, password)
                print("  -> logged in.")
                break
            except Exception as e:
                if attempt < attempts:
                    print(f"  -> attempt {attempt} failed ({e or type(e).__name__}), retrying ...")
                else:
                    print(f"  -> FAILED: {e or type(e).__name__}")

    print("Done. Leaving browser windows open - close them manually when done.")


if __name__ == "__main__":
    main()
