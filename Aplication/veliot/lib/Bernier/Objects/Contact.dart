class Contact {
  String _phoneNumber;
  String _firstName;
  String _lastName;
  String _surname;


  String getPhoneNumber(){
    return _phoneNumber;
  }

  String getFullName(){
    return _lastName+" "+_firstName;
  }

  String getFirstName(){
    return _firstName;
  }

  String getLastName(){
    return _lastName;
  }

  String getSurname(){
    return _surname;
  }

  void setPhoneNumber(String newPNumber){
    _phoneNumber=newPNumber;
  }

  void setFirstName(String newName){
    _firstName=newName;
  }

  void setLastName(String newName){
    _lastName=newName;
  }

  void setSurname(String newName){
    _surname=newName;
  }

  Contact.fromValues(String numb, String firstName, String lastName, String surname){
    _phoneNumber = numb;
    _surname = surname;
    _firstName = firstName;
    _lastName = lastName;
  }

  Contact.fromJson(Map<String, dynamic> json):
    _phoneNumber = json['phone'],
    _surname = json['surname'],
    _firstName = json['firstName'],
    _lastName = json['lastName'];
}