import numpy as np  

stored_sapid = "500119435"
while (True):
    user_sapid = input("Enter your SAP ID: ")
    if user_sapid == stored_sapid:
        print("Matched")
    else:
        print("Not Matched")