# import cv2
# import pytesseract

# pytesseract.pytesseract.tesseract_cmd = 'C:\\Program Files\\Tesseract-OCR\\tesseract'

# img = cv2.imread('text.jpeg')
# img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

# text = pytesseract.image_to_string(img)
# print(text)
def getAadharData(text):
    list_of_text = text.split('\n')
    print("Now we will print other things")
    print(list_of_text)
    list2 = []
    for sent in list_of_text:
        if sent and not(sent.isspace()):
            list2.append(sent)

    print(list2)
    index = 0
    for i in range(len(list2)):
        if 'MALE' in list2[i] or 'FEMALE' in list2[i] or 'Male' in list2[i] or 'Female' in list2[i]:
            index = i

    print(index)

    name = list2[index - 2]
    name = name.split(' ')
    name = ' '.join(name[-3:])
    print("Name", name)

    birth = list2[index-1]
    birth = birth.split(' ')
    birth = birth[-1]
    print("Birth", birth)

    gender = list2[index].split(' ')[-1]
    print("Gender", gender)
    index += 1

    mobile = ' '
    if 'Mobile' in list2[index]:
        mobile = list2[index].split(' ')[-1]
        index += 1

    aadhar = ''.join(list2[index].split(' ')[-3:])

    print("Mobile", mobile)
    print("Aadhar", aadhar)

    return {
        'Name' : name,
        'Mobile' : mobile,
        'Aadhar' : aadhar,
        'DOB' : birth,
        'Gender' : gender
    }

    
# print(getAadharData(text))