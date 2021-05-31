import { By, Key } from 'selenium-webdriver';
import { driver, test, credentials } from 'thousandeyes';

runScript();

async function runScript() {

    await configureDriver();

    const settings = test.getSettings();

    // Load page
    await driver.get(settings.url);

    // Click on 'Normal user'
    await click(By.css('p:nth-child(8) > a'));

    // Click on 'Sign in'
    await click(By.css('[href="#login-modal"]'));

    await click(By.id('username'));

    await typeText('admin', By.id('username'));

    await click(By.name('passwd'));

    await typeText('admin', By.name('passwd'));

    // Click on 'Sign in'
    await click(By.css('.btn-primary'));

     // Make driver sleep for 5 seconds
    await driver.sleep(5000);
}

async function configureDriver() {
    await driver.manage().setTimeouts({
        implicit: 7 * 1000, // If an element is not found, reattempt for this many milliseconds
    });
}

async function click(selector) {
    await simulateHumanDelay();

    const configuredTimeouts = await driver.manage().getTimeouts();
    const clickAttemptEndTime = Date.now() + configuredTimeouts.implicit;

    await reattemptUntil(attemptToClick, clickAttemptEndTime);

    async function attemptToClick() {
        await driver.findElement(selector).click();
    }
}

async function reattemptUntil(attemptActionFn, attemptEndTime) {
    const TIME_BETWEEN_ATTEMPTS = 100;
    let numberOfAttempts = 0;
    let attemptError;
    while (Date.now() < attemptEndTime || numberOfAttempts === 0) {
        try {
            numberOfAttempts += 1;
            await attemptActionFn();
        }
        catch (error) {
            attemptError = error;
            await driver.sleep(TIME_BETWEEN_ATTEMPTS);
            continue; // Attempt failed, reattempt
        }
        attemptError = null;
        break; // Attempt succeeded, stop attempting
    }

    const wasAttemptSuccessful = !attemptError;
    if (!wasAttemptSuccessful) {
        throw attemptError;
    }
}

async function simulateHumanDelay() {
    await driver.sleep(550);
}

async function typeText(value, selector) {
    await simulateHumanDelay();
    const element = await driver.findElement(selector);
    await element.clear();
    await element.sendKeys(value);
}
