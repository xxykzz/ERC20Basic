# ERC20Basic
Una sencilla implementacion del contrato ERC20

Abrimos Remix , creamos una nueva carpeta que llamaremos custom_token, dentro creamos un archivo que se llame ejemploNombre.sol, dentro copiaremos el contenido de ERC20.sol
En nuestra nueva carpeta creamos otro archivo que llamaremos SafeMath.sol donde importaremos una implementacion abreviada de esta libreria.

Utilizamos un compilador que sea >=0.4.4 <0.7.0

# Modificacion de los datos de nuestro token
Si queremos cambiar el nombre, symbol o decimales de nuestro token modificaremos las siguientes variables en nuestro ejemploNombre.sol.

        //nombre de nuestro token
        string public constant name = "XXYKZ";
        //symbol de nuestro token
        string public constant symbol = "XXY";
        //decimales de nuestro token
        uint8 public constant decimals = 18;
        
Una vez que hayamos finalizado nuestra propia implementacion del estandar ERC20 podemos compilarlo y deployarlo.

Nos dirigimos al menu de compilacion de remix y utilizamos un compilador entre las versiones mencionadas.

# Deploy de nuestro contrato

Dentro de nuestra pestaña de deployment en Remix, tendremos que seleccionar el contrato a deployar, elegimos ejemploNombre.sol

Luego le administramos el supply en de nuestro token en el input "supply".

Una vez realizado, deployamos el contrato desde nuestra VM London y tendremos todo listo!
