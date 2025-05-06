import 'package:flutter/material.dart';

// Función principal que inicia la aplicación
void main() {
  runApp(const CalculatorApp());
}

// Widget principal sin estado que configura la aplicación
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Quita el banner de debug de la esquina
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      // Configuración del tema con modo oscuro para simular la calculadora de Mac
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
      ),
      // Pantalla inicial de la aplicación
      home: const CalculatorScreen(),
    );
  }
}

// Widget con estado para la pantalla de la calculadora
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

// Estado del widget que maneja la lógica de la calculadora
class _CalculatorScreenState extends State<CalculatorScreen> {

  // --- VARIABLES DE ESTADO PARA LA CALCULADORA --- //

  // Valor mostrado en la pantalla de la calculadora
  String _output = '0';

  // Valor almacenado en la memoria/acumulador
  String _accumulator = '0';

  // Primer número para operaciones
  double _num1 = 0;

  // Segundo número para operaciones
  double _num2 = 0;

  // Operador seleccionado (+, -, ×, ÷)
  String _operand = '';

  // --- INDICADORES DE ESTADO --- //

  // Indica si se acaba de pulsar un operador
  bool _isOperandPressed = false;

  // Indica si se acaba de pulsar el botón igual
  bool _isEqualPressed = false;

  // Indica si es un cálculo nuevo
  bool _isNewCalculation = true;

  // Método que maneja la lógica cuando se pulsa cualquier botón
  void _buttonPressed(String buttonText) {
    setState(() {
      // --- BOTONES DE CONTROL --- //

      // Si se presiona el botón C (Clear - Limpiar)
      if (buttonText == 'C') {
        // Reinicia la pantalla y las variables de operación
        _output = '0';
        _num1 = 0;
        _num2 = 0;
        _operand = '';
        _isOperandPressed = false;
        _isEqualPressed = false;
        _isNewCalculation = true;
      }

      // Si se presiona el botón AC (All Clear - Borrar Todo)
      else if (buttonText == 'AC') {
        // Reinicia todo, incluyendo el acumulador
        _output = '0';
        _accumulator = '0';
        _num1 = 0;
        _num2 = 0;
        _operand = '';
        _isOperandPressed = false;
        _isEqualPressed = false;
        _isNewCalculation = true;
      }

      // Si se presiona el botón de cambio de signo (+/-)
      else if (buttonText == '+/-') {
        // Cambia el signo del número en pantalla
        if (_output.startsWith('-')) {
          _output = _output.substring(1); // Quita el signo negativo
        } else {
          _output = '-' + _output; // Añade signo negativo
        }
      }

      // Si se presiona el botón de porcentaje (%)
      else if (buttonText == '%') {
        // Convierte el valor a porcentaje (divide por 100)
        double num = double.parse(_output);
        _output = (num / 100).toString();
        // Elimina decimales .0 innecesarios
        if (_output.endsWith('.0')) {
          _output = _output.substring(0, _output.length - 2);
        }
      }

      // --- OPERACIONES DE MEMORIA/ACUMULADOR --- //

      // Si se presiona M+ (Memoria Más)
      else if (buttonText == 'M+') {
        // Suma el valor actual al acumulador
        double currentValue = double.parse(_output);
        double accumulatorValue = double.parse(_accumulator);
        _accumulator = (accumulatorValue + currentValue).toString();
        // Elimina decimales .0 innecesarios
        if (_accumulator.endsWith('.0')) {
          _accumulator = _accumulator.substring(0, _accumulator.length - 2);
        }
      }

      // Si se presiona M- (Memoria Menos)
      else if (buttonText == 'M-') {
        // Resta el valor actual del acumulador
        double currentValue = double.parse(_output);
        double accumulatorValue = double.parse(_accumulator);
        _accumulator = (accumulatorValue - currentValue).toString();
        // Elimina decimales .0 innecesarios
        if (_accumulator.endsWith('.0')) {
          _accumulator = _accumulator.substring(0, _accumulator.length - 2);
        }
      }

      // Si se presiona MR (Memory Recall - Recuperar Memoria)
      else if (buttonText == 'MR') {
        // Muestra el valor del acumulador en pantalla
        _output = _accumulator;
        _isNewCalculation = true;
      }

      // Si se presiona MC (Memory Clear - Borrar Memoria)
      else if (buttonText == 'MC') {
        // Reinicia el acumulador a cero
        _accumulator = '0';
      }

      // --- OPERACIONES CON NÚMEROS --- //

      // Si se presiona el punto decimal
      else if (buttonText == '.') {
        // Solo añade el punto si no existe ya uno
        if (!_output.contains('.')) {
          _output = _output + '.';
        }
        // Si se acaba de presionar un operador o igual, inicia con 0.
        if (_isOperandPressed || _isEqualPressed) {
          _output = '0.';
          _isOperandPressed = false;
          _isEqualPressed = false;
        }
      }

      // Si se presiona un botón numérico
      else if (buttonText == '0' ||
          buttonText == '1' ||
          buttonText == '2' ||
          buttonText == '3' ||
          buttonText == '4' ||
          buttonText == '5' ||
          buttonText == '6' ||
          buttonText == '7' ||
          buttonText == '8' ||
          buttonText == '9') {

        // Si la pantalla muestra 0 o se acaba de presionar operador/igual
        if (_output == '0' || _isOperandPressed || _isEqualPressed || _isNewCalculation) {
          // Reemplaza el contenido con el número presionado
          _output = buttonText;
          _isOperandPressed = false;
          _isEqualPressed = false;
          _isNewCalculation = false;
        } else {
          // Añade el dígito al número existente
          _output = _output + buttonText;
        }
      }

      // --- OPERADORES ARITMÉTICOS --- //

      // Si se presiona un botón de operación
      else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == '×' ||
          buttonText == '÷') {

        // Guarda el primer número y el operador
        _num1 = double.parse(_output);
        _operand = buttonText;
        _isOperandPressed = true;
        _isEqualPressed = false;
      }

      // --- CÁLCULO DEL RESULTADO --- //

      // Si se presiona el botón igual
      else if (buttonText == '=') {
        // Guarda el segundo número
        _num2 = double.parse(_output);

        // Realiza la operación según el operador guardado
        if (_operand == '+') {
          _output = (_num1 + _num2).toString();
        }
        if (_operand == '-') {
          _output = (_num1 - _num2).toString();
        }
        if (_operand == '×') {
          _output = (_num1 * _num2).toString();
        }
        if (_operand == '÷') {
          // Comprueba división por cero
          if (_num2 == 0) {
            _output = 'Error';
          } else {
            _output = (_num1 / _num2).toString();
          }
        }

        // Actualiza los indicadores de estado
        _isEqualPressed = true;
        _isNewCalculation = true;
        _operand = '';

        // Elimina decimales .0 innecesarios
        if (_output.endsWith('.0')) {
          _output = _output.substring(0, _output.length - 2);
        }
      }
    });
  }

  // Método para construir botones estándar (circulares)
  Widget _buildButton(String buttonText, Color buttonColor, Color textColor) {
    return Expanded(
      // El widget ocupa espacio proporcionalmente
      child: Padding(
        // Añade espaciado alrededor del botón
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          // Estilo del botón
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor, // Color de fondo
            foregroundColor: textColor,   // Color de efecto al presionar
            shape: const CircleBorder(),  // Forma circular
            padding: const EdgeInsets.all(20), // Relleno interior
          ),
          // Acción al presionar el botón
          onPressed: () => _buttonPressed(buttonText),
          // Contenido del botón (texto)
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 24.0,             // Tamaño de fuente
              fontWeight: FontWeight.bold, // Negrita
              color: textColor,           // Color del texto
            ),
          ),
        ),
      ),
    );
  }

  // Método para construir el botón cero (forma especial como en Mac)
  Widget _buildZeroButton(Color buttonColor, Color textColor) {
    return Expanded(
      // Ocupa el doble de espacio que los botones normales
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: textColor,
            shape: const StadiumBorder(), // Forma alargada con bordes redondeados
            padding: const EdgeInsets.all(20),
          ),
          onPressed: () => _buttonPressed('0'),
          // Alínea el texto a la izquierda (como en Mac)
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                '0',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definición de los colores de los botones
    Color operationColor = Colors.orange;         // Naranja para operaciones
    Color functionColor = Colors.grey.shade600;   // Gris medio para funciones
    Color numberColor = Colors.grey.shade800;     // Gris oscuro para números
    Color textColor = Colors.white;               // Blanco para el texto

    // Estructura de la interfaz
    return Scaffold(
      // Fondo negro como en calculadora de Mac
      backgroundColor: Colors.black,
      body: SafeArea(
        // Asegura que los elementos estén dentro del área visible
        child: Column(
          children: [
            // --- PANTALLA DE LA CALCULADORA --- //
            Expanded(
              // Proporción de espacio para la pantalla
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                // Alinea el contenido abajo a la derecha
                alignment: Alignment.bottomRight,
                child: Column(
                  // Alinea el contenido a la derecha
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // Alinea el contenido al final (abajo)
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Muestra el valor del acumulador
                    Text(
                      'M: $_accumulator',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    // Espacio entre textos
                    const SizedBox(height: 8.0),
                    // Muestra el resultado principal
                    Text(
                      _output,
                      style: const TextStyle(
                        fontSize: 64.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      // Limita a una línea con desbordamiento
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // --- SECCIÓN DE BOTONES --- //
            Expanded(
              // Proporción de espacio para los botones
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Primera fila de botones (AC, +/-, %, ÷)
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('AC', functionColor, textColor),
                          _buildButton('+/-', functionColor, textColor),
                          _buildButton('%', functionColor, textColor),
                          _buildButton('÷', operationColor, textColor),
                        ],
                      ),
                    ),

                    // Segunda fila de botones (MC, 7, 8, 9, ×)
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('MC', functionColor, textColor),
                          _buildButton('7', numberColor, textColor),
                          _buildButton('8', numberColor, textColor),
                          _buildButton('9', numberColor, textColor),
                          _buildButton('×', operationColor, textColor),
                        ],
                      ),
                    ),

                    // Tercera fila de botones (MR, 4, 5, 6, -)
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('MR', functionColor, textColor),
                          _buildButton('4', numberColor, textColor),
                          _buildButton('5', numberColor, textColor),
                          _buildButton('6', numberColor, textColor),
                          _buildButton('-', operationColor, textColor),
                        ],
                      ),
                    ),

                    // Cuarta fila de botones (M+, 1, 2, 3, +)
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('M+', functionColor, textColor),
                          _buildButton('1', numberColor, textColor),
                          _buildButton('2', numberColor, textColor),
                          _buildButton('3', numberColor, textColor),
                          _buildButton('+', operationColor, textColor),
                        ],
                      ),
                    ),

                    // Quinta fila de botones (M-, 0, ., =)
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('M-', functionColor, textColor),
                          _buildZeroButton(numberColor, textColor),
                          _buildButton('.', numberColor, textColor),
                          _buildButton('=', operationColor, textColor),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}