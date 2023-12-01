import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);
 @override
 Widget build(BuildContext context) {
 return const MaterialApp(
 title: 'User Input',
 home: MyInputPage(),
 );
 }
}
class MyInputPage extends StatefulWidget {
 const MyInputPage({Key? key}) : super(key: key);
 @override
 State<MyInputPage> createState() => _MyInputPageState();
}
class _MyInputPageState extends State<MyInputPage> {
 final TextEditingController _controller = TextEditingController();
 bool _isValid = true;
 String inputValue = '';
 @override
 void dispose() {
 _controller.dispose();
 super.dispose();
 }
 void _validateUserInput() {
 inputValue = _controller.text.trim();
 RegExp alphabetic = RegExp(r'^[a-zA-Z]+$');
 setState(() {
 if (inputValue.isEmpty || !alphabetic.hasMatch(inputValue)) {
 _isValid = false;
 } else {
 _isValid = true;
 print('Masukan pengguna: $inputValue');
 }
 });
 }
 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: AppBar(
 title: const Text('User Input'),
 ),
 body: Padding(
 padding: const EdgeInsets.all(16),
 child: Column(
 mainAxisAlignment: MainAxisAlignment.center,
 crossAxisAlignment: CrossAxisAlignment.stretch,
 children: [
 TextField(
 controller: _controller,
 decoration: InputDecoration(
 border: const OutlineInputBorder(),
 labelText: 'Masukkan Teks',
 errorText:
 _isValid ? null : 'Hanya huruf alfabet diperbolehkan',
 suffixIcon: _controller.text.isNotEmpty ?
 IconButton(
 onPressed: () {
 setState(() {
 _controller.clear();
 });
 },
 icon: const Icon(Icons.clear),
 ) : null,
 ),
 onChanged: (value){
 setState(() {
 inputValue = value;
 });
 },
 ),
 const SizedBox(height: 20),
 ElevatedButton(
 onPressed: () {
 _validateUserInput();
 },
 child: const Text('Kirim'),
 ),
 ],
 ),
 ),
 );
 }
}