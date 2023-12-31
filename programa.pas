
Program InformesMN;

Uses sysutils;

Type 
  reg_experimentos = Record
    clave : Record
      cod_dep: longint;
      cod_exp: longint;
    End;
    cod_muestra: longint;
    nombre: string[50];
    riqueza: real;
    propiedades: string[100];
    peso: real;
  End;
  arch_exps = file Of reg_experimentos;

  reg_salida = Record
    cod_muestra: longint;
    nombre: string[50];
    propiedades: string[100];
  End;
  arch_sal = file Of reg_salida;

Var 
  RegExps: reg_experimentos;
  arch: arch_exps;

  SalExps: reg_salida;
  arch_salida: arch_sal;

  sec: file Of char;
  v: char;

  resg_departamento, resg_experimento, total_muestras, total_generado,
  total_secuencia, a, b: longint;
  peso_efectivo: real;
  cadena: string;

Procedure Abrir_E;
Begin
  assign(arch, 'muestras.dat');
  {$i-}
  reset(arch);
  {$i+}

  If IOResult <> 0 Then
    writeln('No se pudo cargar el archivo de entrada.');
End;

Procedure Abrir_S;
Begin
  assign(arch_salida, 'muestras_salida.dat');
  rewrite(arch_salida);
End;

Procedure Crear_S;
Begin
  assign(sec, 'secuencia.txt');
  rewrite(sec);
End;

Procedure Inicializar_Program;
Begin
  total_muestras := 0;
  total_generado := 0;
  total_secuencia := 0;
  resg_departamento := -1;
  resg_experimento := -1;
End;

Procedure corte_experimento;
Begin
  If (resg_departamento <> -1) And (resg_experimento <> -1) Then
    Begin
      writeln(resg_departamento:13, ' | ', resg_experimento:12, ' | ',
              total_muestras:5);
    End;
  resg_experimento := RegExps.clave.cod_exp;
  total_muestras := 0;
End;

Procedure corte_departamento;
Begin
  corte_experimento;
  resg_departamento := RegExps.clave.cod_dep;
End;

Procedure Generar_Secuencia;
Begin
  If RegExps.riqueza >= 95 Then
    Begin
      total_secuencia := total_secuencia + 1;

      //Codigo de la muestra
      Str(RegExps.cod_muestra, cadena);

      For a := 1 To Length(cadena) Do
        Begin
          v := cadena[a];
          Write(sec, v);
        End;
      Write(sec, '+');

      cadena := RegExps.nombre;

      //Nombre de la muestra
      For b := 1 To Length(RegExps.nombre) Do
        Begin
          v := cadena[b];
          Write(sec, v);
        End;

      //Separamos las muestras - Codigo+Nombre#
      Write(sec, '#');
    End;
End;

Procedure Generar_Archivo;
Begin
  If RegExps.riqueza >= peso_efectivo Then
    Begin
      total_generado := total_generado + 1;
      SalExps.cod_muestra := RegExps.cod_muestra;
      SalExps.nombre := RegExps.nombre;
      SalExps.propiedades := RegExps.propiedades;
      write(arch_salida, SalExps);
    End;
End;

//Algoritmo

Begin
  //Abrimos los archivos de entrada
  Abrir_E;
  Abrir_S;
  Crear_S;

  //Inicializamos variables y contadores
  Inicializar_Program;

  //Solicitamos el dato de entrada al usuario
  writeln('Bienvenido, ingrese un peso efectivo:');
  readln(peso_efectivo);

  writeln('Cantidad de muestras por departamento y experimento:');
  writeln(' Departamento | Experimento  | Cantidad ');

  While Not EOF(arch) Do
    Begin
      Read(arch, RegExps);

      If (resg_departamento <> RegExps.clave.cod_dep) Then
        corte_departamento
      Else
        If (resg_experimento <> RegExps.clave.cod_exp) Then
          corte_experimento;

      total_muestras := total_muestras + 1;
      Generar_Secuencia;
      Generar_Archivo;
    End;

  corte_departamento;

  writeln(' ');
  writeln('Secuencia generada con ', total_secuencia,' muestras.');
  writeln('Se genero un archivo de salida con ', total_generado,
          ' muestras.');
  writeln(' ');

  //Cerramos los archivos 
  Close(sec);
  Close(arch);
  Close(arch_salida);
End.
