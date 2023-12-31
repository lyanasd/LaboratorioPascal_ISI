
Program LeerArchivoSalida;

Type 
  reg_salida = Record
    cod_muestra: longint;
    nombre: string[50];
    propiedades: string[100];
  End;
  arch_sal = file Of reg_salida;

Var 
  SalExps: reg_salida;
  arch_salida: arch_sal;
  archivo_vacio: boolean;
  cantidad: longint;

Procedure Abrir_Archivo(Var arch_local: arch_sal);
Begin
  assign(arch_local, 'muestras_salida.dat');
  {$i-}
  reset(arch_local);
  {$i+}

  If IOResult <> 0 Then
    archivo_vacio := True // El archivo no existe o no se puede abrir
  Else
    archivo_vacio := False;
End;

Begin
  cantidad := 0;
  Abrir_Archivo(arch_salida);

  If archivo_vacio Then
    writeln('El archivo no existe o está vacío.')
  Else
    Begin
      writeln('Contenido del archivo:');
      writeln('     Nombre     |        Propiedades    ');

      While Not EOF(arch_salida) Do
        Begin
          Read(arch_salida, SalExps);
          writeln(SalExps.nombre:15, ' | ', SalExps.propiedades:20);
          cantidad := cantidad + 1;
        End;
      writeln('Cantidad:', cantidad);
      Close(arch_salida);
    End;
End.
