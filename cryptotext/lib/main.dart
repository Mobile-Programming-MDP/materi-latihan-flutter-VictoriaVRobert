import 'dart:convert';

import 'package:encrypt/encrypt.dart%20';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

void main() {
  runApp(CryptoText());
}

class CryptoText extends StatelessWidget {
  const CryptoText({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CryptoText',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  // Kunci untuk enkripsi dan dekripsi
  final encrypt.Key _key = encrypt.Key.fromLength(32);
  // Initial vector untuk enkripsi dan dekripsi
  final iv = encrypt.IV.fromLength(16);

  String _encryptedText = '';
  String _decryptedText = '';
  String? _errorText;
  bool _isDecryptButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CryptoText"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Input text',
                errorText: _errorText,
                border: const OutlineInputBorder(),
              ),
              onChanged: _onTextChanged,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                String inputText = _textEditingController.text;

                if (inputText.isNotEmpty) {
                  _encryptText(inputText);
                } else {
                  setState(() {
                    _errorText = 'Input cannot be empty';
                  });
                }
              },
              child: const Text('Encrypt'),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Encrypted text: $_encryptedText',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _isDecryptButtonEnabled && _encryptedText.isNotEmpty? (){
              String inputText = _encryptedText;
              final encrypted = encrypt.Encrypted.fromBase64(inputText);
              _decryptText(encrypted.base64);
              } : null, 
              child: const Text('Decrypt'),
              ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Decrypted text: $_decryptedText',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
void _onTextChanged(String text) {
      setState(() {
        _isDecryptButtonEnabled = text.isNotEmpty;
        _encryptedText = '';
        _decryptedText = '';
        _errorText = '';
        _errorText = null;
      });
    }
  void _encryptText(String text) {
      try {
        if (text.isNotEmpty) {
          final encrypter = 
            encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.ecb));
          final encrypted = encrypter.encrypt(text);
          setState(() {
            _encryptedText = encrypted.base64;
          });
        } else {
          print('Text to encrypt cannot be empty');
          // Tambahkan pesan yang sesuai jika teks kosong
        }
      } catch (e, stackTrace) {
        print('Error encrypting text: $e, stackTrace: $stackTrace');
        //Penanganan kesalahan yang sesuai
      }
    }

  void _decryptText(String text) {
    try {
      if (text.isNotEmpty) {
        final encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.ecb));
        final decrypted = encrypter.decrypt64(text);

        setState(() {
          _decryptedText = decrypted;
        });
      } else {
        print('Text to decrypt cannot be empty');
      }
    } catch (e, stackTrace) {
      print('Error decrypting text: $e, stackTrace: $stackTrace');
    }
  }
}
