# -*- coding: utf-8 -*-
"""
Created on Fri Dec 22 09:23:17 2017

@author: Anike
"""

import time
import pandas as pd
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.keys import Keys
from bs4 import BeautifulSoup

def init_driver(filepath):
    driver = webdriver.Chrome(executable_path = filepath)
    driver.wait = WebDriverWait(driver, 10)
    return(driver)

driver = init_driver('C:/Users/Anike/Documents/chromedriver.exe')

def navigate_to_website(driver, site):
    driver.get(site)
    
navigate_to_website(driver, "http://trademarks.reedtech.com/tmappxml.php#2018")

list_links = driver.find_elements(By.CSS_SELECTOR, "a[href*='downloads']")

for i in list_links:
        url = i.get_attribute('href')
        driver.implicitly_wait(10)
        driver.get(url)

