function O=fuzzyedge(name)
% fuzzyedge(imname)
% 
% Proporciona una imagen en escala de grises con bordes detectados
% utilizando un sistema de inferencia difuso propuesto por Jaideep Kaur - 
% Poonam Sethi.
% (https://research.ijcaonline.org/volume77/number15/pxc3891351.pdf)
% 
% Uso
% Toma como entrada el nombre de una imagen RGB que se encuentre en el
% Directorio de trabajo, su salida es una imagen en escala de grises.
% Se debe proporcionar el archivo .fis del sistema de inferencia difuso con
% el nombre ''kaur_sethi.fis'.

    % Se carga el sistema de inferencia difuso
    fis=readfis('kaur_sethi.fis');
    % Lectura de la imagen
    Aog=imread(name);
    % Conversión de la imagen a escala de grises
    A=rgb2gray(Aog);
    [row, column] = size(A);
    A = double(A);

    % Matrices de gradientes en el eje X e Y
    Gx =[-1 1];
    Gy = Gx(:);
    
    % Aplica la convolución a A con Gx, y obtiene la gradiente en el eje X
    Ax = double(uint8(255 * mat2gray(conv2(A,Gx,'same'))));
    % Aplica la convolución a A con Gy, y obtiene la gradiente en el eje Y
    Ay = double(uint8(255 * mat2gray(conv2(A,Gy,'same'))));

    % Matriz de salida luego de aplicar el sistema difuso en cada eje
    Ox = zeros(row,column,"double");
    Oy = zeros(row,column,"double");

    for r=1:row-1
      for c=1:column-1
        % Vector temporal que representa la ventana 2*2 [P1 P2 P3 P4]
        T = [Ax(r,c:c+1) A(r+1,c:c+1)];
        % Se evalua usando el sistema de inferencia y se asigna el
        % resultado al pixel P1 de la matriz de salida.
        Ox(r,c) = evalfis(fis, T);
        % Vector temporal que representa la ventana 2*2 [P1 P2 P3 P4]
        T = [Ay(r,c:c+1) A(r+1,c:c+1)];
        % Se evalua usando el sistema de inferencia y se asigna el
        % resultado al pixel P1 de la matriz de salida.
        Oy(r,c) = evalfis(fis, T);
      end
    end
    
    O = abs(Oy - Ox);
    O = uint8(O);
    figure;
    imshow(Aog);
    figure;
    imshow(uint8(A));
    figure;
    imshow(uint8(Ax));
    figure;
    imshow(uint8(Ay));
    figure;
    imshow(O);
end