import 'dart:math';

class Calculator {


  static List<List<int>> arrayMultiply(List<List<int>> array1, List<List<int>> array2) {

    // Проверка, чтобы количество столбцов в первой матрице равно количеству строк во второй
    if (array1[0].length != array2.length) {
      throw Exception('Невозможно перемножить матрицы: количество столбцов в первой матрице должно совпадать с количеством строк во второй.');
    }

    // Результирующая матрица с размером array1.length (число строк в первой матрице) на array2[0].length (число столбцов во второй матрице)
    List<List<int>> result = List.generate(array1.length, (_) => List.generate(array2[0].length, (_) => 0));

    // Перемножение матриц
    for (int i = 0; i < array1.length; i++) {
      for (int j = 0; j < array2[0].length; j++) {
        for (int k = 0; k < array1[0].length; k++) {
          result[i][j] += array1[i][k] * array2[k][j]; // Суммируем произведения
        }
      }
    }

    return result;
  }

// Функция для получения минора матрицы (удаление строки и столбца)
  static List<List<int>> _getMinor(List<List<int>> matrix, int row, int col) {
    List<List<int>> minor = [];

    for (int i = 0; i < matrix.length; i++) {
      if (i == row) continue; // Пропустить текущую строку

      List<int> newRow = [];
      for (int j = 0; j < matrix[i].length; j++) {
        if (j == col) continue; // Пропустить текущий столбец
        newRow.add(matrix[i][j]);
      }
      minor.add(newRow);
    }

    return minor;
  }


  // Функция для вычисления определителя
  static int determinant(List<List<int>> matrix) {
    int n = matrix.length;

    if(n==1){
      return matrix[0][0];
    }
    // Базовый случай для матрицы 2x2
    if (n == 2) {
      return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0];
    }

    int det = 0;
    for (int col = 0; col < n; col++) {
      // Разложение по первой строке (строка 0)
      var cofactor = pow(-1, col) * matrix[0][col];
      det += (cofactor * determinant(_getMinor(matrix, 0, col))).toInt();
    }

    return det;
  }



  static int alg(List<List<int>> matrix,int row,int col){
    int n = matrix.length;
/*    if(n==2){
      return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0];
    }*/
    var cofactor = pow(-1, row + col);


    var minor = _getMinor(matrix, row, col);
    var det =  determinant(minor);

    return (cofactor*det).toInt();
  }

  static int modWithSign(int a, int b) {
    return ((a % b) + b) % b;
  }

  static List<int> getDivisorsList(int value){
    List<int> result=[];

    for(int i=2;i<=value;i++){
      if(value%i==0){
        result.add(i);
      }
    }

    return result;
  }

  static transparentArray(List<List<int>> array){
    List<List<int>> newArray = List.generate(array.length, (_){
      return List.generate(array.length, (_)=>0);
    });

    for(int i=0;i<array.length;i++){
      for(int j=0;j<array[i].length;j++){
        newArray[i][j]=array[j][i];
      }
    }

    return newArray;
  }

  static List<List<int>> matrixConstantMultiply(List<List<int>> array, int value,{int? mod}){
    for(int i=0;i<array.length;i++){
      for(var j=0;j<array[i].length;j++){
        array[i][j]*=value;
        mod !=null ? array[i][j]=array[i][j].remainder(mod) : null;

      }
    }

    return array;
  }

  static int modularInverse(int a, int m) {
    int m0 = m, t, q;
    int x0 = 0, x1 = 1;

    if (m == 1) return 0;

    while (a > 1) {
      // q — это частное
      q = a ~/ m;
      t = m;

      // m — остаток от деления
      m = a % m;
      a = t;
      t = x0;

      // Обновляем x0 и x1
      x0 = x1 - q * x0;
      x1 = t;
    }

    if (x1 < 0) x1 += m0;

    return x1;
  }


  static List<List<int>> inversedModMatrix(List<List<int>> array, int mod){

    int n = array.length;
    List<List<int>> algebraicMatrix = List.generate(n, (_){
      return List.generate(n, (_)=>0);
    });

    for(int i=0;i<n;i++){
      for(int j=0;j<n;j++){
        int alg = Calculator.alg(array, i, j);
        algebraicMatrix[i][j]=Calculator.modWithSign(alg, mod);
      }
    }
    print("Матрица алгебраических дополнений ${algebraicMatrix}");



    int keyDeterminant = Calculator.determinant(array).remainder(mod);

    if (keyDeterminant < 0) keyDeterminant += mod;

    int inverseDeterminant = Calculator.modularInverse(keyDeterminant.remainder(mod), mod);

    var inverseMatrix = Calculator.matrixConstantMultiply(algebraicMatrix, inverseDeterminant, mod: mod);


    for (var i = 0; i < inverseMatrix.length; i++) {
      for (var j = 0; j < inverseMatrix[i].length; j++) {
        inverseMatrix[i][j] = Calculator.modWithSign(inverseMatrix[i][j], mod);
      }
    }





    List<List<int>> transparentMatrix = Calculator.transparentArray(inverseMatrix);

    return transparentMatrix;

  }


}
