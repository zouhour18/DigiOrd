

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
//import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../data/authentification.dart';
import 'listeOrdonnance.dart';
import '../data/CreateOrd.dart';




class Addord extends StatefulWidget {
  @override
  String idmedecin;
  String idpatient;
  String doctor;
  String patient;
  Addord({required this.idmedecin,required this.idpatient,required this.doctor,required this.patient});
  _AddordState createState() => _AddordState();
}

class _AddordState extends State<Addord> {

  /* variable */
  final _formKey = GlobalKey<FormState>();
  final _Key = GlobalKey<FormState>();

  //final CollectionReference profilList = FirebaseFirestore.instance.collection('profileInfoPatient');
  final CreateOrd ord=CreateOrd();


  TextEditingController _medicController = TextEditingController();
  TextEditingController _doseController = TextEditingController();
  TextEditingController _parjourController = TextEditingController();
  TextEditingController _nbrjourController = TextEditingController();

  TextEditingController _signateurController = TextEditingController();


  final controllerqr = TextEditingController();

  String medic = '';
  int dose = 0;
  int nbrjour = 0;
  int parjour = 0;
  List itemsList = [];

  String random='X';
  DateTime date = new DateTime.now();
  String signature='';
  String idd='X';
  String numero='';
  int n=0;









  Widget buildAff() {
    final Stream <QuerySnapshot> users = FirebaseFirestore.instance.collection('profileInfoPatient').doc(widget.idpatient).collection('ListeOrdonnance').doc(random).collection("ListeMedicament").snapshots();

    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child:
      StreamBuilder<QuerySnapshot>(
        stream: users,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot>snapshot,) {
          if (snapshot.hasError) {
            return Text('Something went wrong.');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }
          final data = snapshot.requireData;
          return ListView.builder(
            //scrollDirection: Axis.vertical,
            //physics: NeverScrollableScrollPhysics(),
            //addAutomaticKeepAlives: false,
            //cacheExtent: 100.0,
            itemCount: data.size,
            itemBuilder: (context, index) {
              itemsList.add(data.docs[index]);
              return
                Table(
                  border: TableBorder.all(),
                  columnWidths: {
                    0: FractionColumnWidth(0.35),
                    1: FractionColumnWidth(0.15),
                    2: FractionColumnWidth(0.25),
                    3: FractionColumnWidth(0.25),
                  },
                  children: [

                    buildRow([
                      '${data.docs[index]['Medicament']}',
                      '${data.docs[index]['dose']}',
                      '${data.docs[index]['par jour']}',
                      '${data.docs[index]['nombre de jour']}'
                    ]),
                  ],
                );
            },
          );
        },

      ),

    );
  }




  Widget buildqr(BuildContext context) {
    return Container(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          //buildsave(context),
          Row(
            children: [
              Expanded(child: buildTextField(context)),
              const SizedBox(width: 12),
              FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.done, size: 30),
                onPressed: () {
                  setState(() {});
                },
              )
            ],
          ),

          SizedBox(height: 10),
          BarcodeWidget(
            barcode: Barcode.qrCode(),
            color: Colors.black,
            data: controllerqr.text ,
            width: 500,
            height: 50,
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget buildTextField(BuildContext context) => TextFormField(
    controller: controllerqr,
    onChanged: (value){
      signature=value;
    },
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'entrer votre signature !';
      } else
        return null;
    },
    style: TextStyle(
      color: Colors.black,
      //fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    decoration: InputDecoration(
      hintText: 'Enter Signature',
      hintStyle: TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
      ),
    ),
  );






  /*      **************            */
  @override
  /*void initState(){
    getData();
    super.initState();
  }*/
  Widget build(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height;
    // final double width = MediaQuery.of(context).size.width;
    return Scaffold(


      appBar:
      AppBar(title: Text(
        'Zone Médecin',
        style:TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ), backgroundColor: Colors.cyan.shade700,


        automaticallyImplyLeading: false,
        actions: [
          RaisedButton(
            onPressed: () async {

              //Navigator.push(context, MaterialPageRoute(builder: (context) => accueil()));

              Navigator.pop(context);
            },
            child : Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            color: Colors.cyan.shade700,
          ),
        ],
      ),


      backgroundColor: Colors.white30,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: <Widget>[
                  Text(
                    'Ordonnance Médicale',
                    style: TextStyle(
                      fontSize: 40,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = Colors.cyan.shade700,
                    ),
                  ),
                  Text(
                    'Ordonnance Médicale',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.cyan.shade50,
                    ),
                  )
                ],
              ) ,
            ],
          ),
          Expanded(
            child: Column(
                children: [
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 32,right: 30, top: 25, bottom: 10),
                        child: Text(
                          //'Date:${widget.index['date'].toDate().toString()}',
                          // 'Date : ${formattedDate(widget.index['date'])}',
                          'Date: ${date.day}/${date.month}/${date.year}',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Stack(
                        children: [
                          Container(
                            height: 80,
                            width:500,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(50),
                                  topRight: Radius.circular(50)),
                              color: Colors.cyan.shade50,
                            ),
                          ),

                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 32, top: 25, bottom: 10),
                                child: new Text(
                                  "Nom du Médecin: ${widget.doctor}",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.cyan.shade700,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),

                            ],
                          )
                        ],
                      ),

                      new Container(
                        margin: const EdgeInsets.only(bottom: 10, top: 50),
                        //height: 150,
                        padding: const EdgeInsets.only(left: 20, right: 10, bottom: 20),
                        child: new Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.cyan,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                offset: Offset(-10.0, 10.0), //(x,y)
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.only(left: 32, top: 25, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new FlatButton(

                                  onPressed: (){
                                    setState(() {});
                                    random= Random().nextInt(500).toString();
                                  },
                                  child: new Text(
                                    "Numéro d\'ordonnance: $random",
                                    style: new TextStyle(
                                      fontSize: 30.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Stack(
                        children: [
                          Container(
                            height: 80,
                            width:500,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(50),
                                  topRight: Radius.circular(50)),
                              color: Colors.cyan.shade50,
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 32, top: 25, bottom: 10),
                                child: new Text(
                                  "Nom du Patient: ${widget.patient}",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.cyan.shade700,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 10,right: 50),
                        child: Row(
                          children: [
                            Icon(Icons.add_circle_rounded,
                                color: Colors.cyan),
                            SizedBox(
                              width: 20,
                            ),
                            RaisedButton(onPressed: () {
    openDialogueBox(context);

                            },
                              child: Text('Ajouter Médicament',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              color: Colors.white70,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              textColor: Colors.cyan.shade600,
                              padding: EdgeInsets.all(15.0),
                              splashColor: Colors.cyan.shade600,
                            ),
                          ],
                        ),
                      )




                    ],
                  ),
                ]),
          ),
          Expanded(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: GestureDetector(
                    child: Stack(
                        children: <Widget>[
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                              child:Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Table(
                                      border: TableBorder.all(),
                                      columnWidths: {
                                        0: FractionColumnWidth(0.35),
                                        1: FractionColumnWidth(0.15),
                                        2: FractionColumnWidth(0.25),
                                        3: FractionColumnWidth(0.25),
                                      },
                                      children: [
                                        buildRow(['Médicament', 'Dose', 'NbrJour','NbrFois par Jour'],isHeader: true),
                                      ],
                                    ),
                                    SizedBox(
                                      // height: 10,
                                      child:buildAff(),
                                    ),
                                    SizedBox(height: 10,),
                                    buildqr(context),
                                    SizedBox(height: 10,),


                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.save_rounded,
                                              color: Colors.cyan),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          RaisedButton(onPressed: () {
                                            ord.AjouterOrd(date, widget.doctor, widget.idmedecin, widget.patient, signature, widget.idpatient, random);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Sending data to cloud firesstore'),
                                              ),
                                            );
                                            //Navigator.pop(context);

                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (_) =>gerer_ord(
                                              idpatient:widget.idpatient,
                                              idmedecin:widget.idmedecin ,
                                              //patient: widget.patient,
                                              doctor: widget.doctor,
                                            )));

                                          },
                                            child: Text('Save',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                            color: Colors.white60,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            textColor: Colors.cyan.shade600,
                                            padding: EdgeInsets.all(15.0),
                                            splashColor: Colors.cyan.shade300,
                                          ),
                                        ],
                                      ),






                                  ],
                                ),
                              ),
                            ),
                          )
                        ]
                    )
                )
            ),
          ),
          /*------------------zou----------------*/
        ],
      ),
    );
  }
  TableRow buildRow(List<String> cells, {bool isHeader = false}) =>
      TableRow(
          children: cells.map((cell) {
            final style = TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
            );

            return Padding(
              padding: const EdgeInsets.all(12),
              child: Center(child: Text(cell)),
            );
          }).toList());

  openDialogueBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ajouter Medicament'),
            content: Container(
              height: 300,
              child: Form(
                key: _Key,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _medicController,
                      decoration: InputDecoration(hintText: 'medicament'),
                      onChanged: (value) {
                        medic = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrez nom de medicament!';
                        } else
                          return null;
                      },
                    ),
                    TextFormField(
                      controller: _doseController,
                      decoration: InputDecoration(hintText: 'dose'),
                      onChanged: (value) {
                        dose = int.parse(value);
                      },

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Quel est la dose de medicament?';
                        } else
                          return null;
                      },
                    ),
                    TextFormField(
                      controller: _parjourController,
                      decoration: InputDecoration(hintText: 'parjour'),
                      onChanged: (value) {
                        parjour = int.parse(value);
                      },

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Combien de fois par jour?';
                        } else
                          return null;
                      },
                    ),
                    TextFormField(
                      controller: _nbrjourController,
                      decoration: InputDecoration(hintText: 'nbrJour'),
                      onChanged: (value) {
                        nbrjour = int.parse(value);
                      },

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'combien de jour utilise ce médicament?';
                        } else
                          return null;
                      },
                    )
                  ],
                ),
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  if (_Key.currentState!.validate()) {
                    numero=n.toString();
                    submitAction(context);
                    Navigator.pop(context);
                  }
                  n=n+1;
                },
                child: Text('Submit'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  submitAction(BuildContext context) {
    ord.AjouterMedic(random, dose, medic, numero, parjour, widget.idpatient, nbrjour);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sending data to cloud firesstore'),
      ),
    );
    _medicController.clear();
    _doseController.clear();
    _parjourController.clear();
    _nbrjourController.clear();
  }
String formattedDate(timeStamp) {
  var dateFromTimeStamp =
  DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
  return DateFormat('dd-MM-yyyy').format(dateFromTimeStamp);
}
}
