//SPDX-License-Identifier: MIT
pragma solidity >= 0.4.4 < 0.7.0;
pragma experimental ABIEncoderV2;

//importamos safeMath
import "./SafeMath.sol";

// --------------------- INTERFACE ---------------------------//

//Creamos la interface de nuestro token, las funciones que podran accederse desde fuera
//Aqui se definen los parametros de entrada asi como tambien los retornos de cada una de nuestras funciones, tambien como eventos que se emitan automaticamente
interface IERC20 {
    
    // --------------------- FUNCIONES ---------------------------//

    //Devuelve la cantidad de tokens en existencia, la definimos, pero la implementaremos en el contrato
    function totalSupply() external view returns(uint256);
    
    //Devuelve la cantidad de tokens de una direccion indicada por parametros, esta funcion consulta la addres y nos hace el return. sera implementada en nuestro contrato
    function balanceOf(address account) external view returns(uint256);
    
    //Devuelve el numero de tokens que el (spender) podra agastar en nombre del propietario(owner)
    function allowance(address owner, address spender) external view returns(uint256);
    
    //Devuelve un valor booleano resultado de la operacion indicada, se decide si la transaccion es posible o no
    function transfer(address recipient, uint256 amount) external returns(bool);
    
    //Devuelve un booleano con el resultado de la operacion de gasto
    function aprove(address spender, uint256 amount) external returns(bool);
    
    //Devuelve un valor booleano con el resultado de la operacion de paso de una cantidad de tokens usando el metodo allowance
    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);
    
    // --------------------- EVENTOS ---------------------------//
    
    //Evento que se debe emitir cuando una cantidad de tokens pase de un origen a un destino
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    //Evento que se debe emitir cuando se establece una asignacion con el metodo allowance
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


// --------------------- CONTRATO ---------------------------//

//Creamos nuestro conrato e implementamos nuestra interface
//Implementacion de las funciones del token ERC20
contract ERC20basic is IERC20 {
    
        // --------------------- VARIABLES DEL CONTRATO ---------------------------//
        
        //nombre de nuestro token
        string public constant name = "XXYKZ";
        //symbol de nuestro token
        string public constant symbol = "XXY";
        //decimales de nuestro token
        uint8 public constant decimals = 18;
        
        
        // --------------------- MAPPINGS ---------------------------//
        
        mapping (address => uint) balances;
        mapping(address => mapping(address => uint)) allowed;
        //total totalSupply, PRIVADO
        uint256 totalSupply_;
        
        // --------------------- CONSTRUCTOR ---------------------------//
    
        constructor(uint256 initialSupply) public {
            totalSupply_ = initialSupply;
            balances[msg.sender] = totalSupply_;
        }
    
        // --------------------- IMPLEMENTACIONES ---------------------------//
        //Indicamos la disponibilidad de estos eventos en nuestro contrato, utilizacion blockchain
        event Transfer(address indexed from, address indexed to, uint256 tokens);
        event Approval(address indexed owner, address indexed spender, uint256 tokens );
        
        //Utilizamos SafeMath para nuestras operaciones aritmeticas
        using SafeMath for uint256;
        
        //mapeo , 
        
    
        //implementacion cantidad total de tokens
        function totalSupply() public override view returns(uint256){
            return totalSupply_;
        }
        
        //funcion que hace un incremento del totalSupply_ con nuevos tokens;
        function increaseTotalSupply(uint newTokenAmount) public {
            totalSupply_ += newTokenAmount;
            balances[msg.sender] += newTokenAmount; 
        }
        
        
        //implementacion balance de un poseedor               
        function balanceOf(address tokenOwner) public override view returns(uint256){
            return balances[tokenOwner];
        }
        
        //Implementacion (delegate = spender)
        function allowance(address owner, address delegate) external override view returns(uint256){
            return allowed[owner][delegate];
        }
        
        //Implementacion
        function transfer(address recipient, uint256 numTokens) public override returns(bool){
            
            //validamos que el sender tenga los tokens que quiere transferir
            require(numTokens <= balances[msg.sender]);
            // llevamos adelante la resta de forma segura con el metodo sub() importado de la libreria safeMath, al [msg.sender] que es quien ha iniciado la transferencia
            balances[msg.sender] = balances[msg.sender].sub(numTokens);
            // sumamos los tokens restados al [msg.sender] al nuevo owner (recipient)
            balances[recipient] = balances[recipient].add(numTokens);
            
            //emitimos el evento Transfer para que todos los que esten conectadosal contrato contengan el nuevo balance y distribucion de ellos
            emit Transfer(msg.sender, recipient, numTokens);
            return true;
        }
        
        //Implementacion
        function aprove(address delegate, uint256 numTokens) public override returns(bool){
            
            //permitimos que el delagado disponga del numero de tokens que definimos en la transfer
            allowed[msg.sender][delegate] = numTokens;
            // emitimos el evento de delegacion de los tokens para que el recipient pueda utilizarlos
            emit Approval(msg.sender, delegate, numTokens);
            
            return true;
        }

        //aca somos el delegate y funcionamos como intermediario de una transferencia , es decir podemos "gastar" tokens en nombre del owner y transferirlos a un buyer
        function transferFrom(address owner, address buyer, uint256 numTokens) public override returns(bool){
            
            require(numTokens <= balances[owner]);
            require(numTokens <= allowed[owner][msg.sender]);
            
            //restar los tokens al owner
            balances[owner] = balances[owner].sub(numTokens);
            // restar el numTokens del allowed, es decir el intermediario de la venta
            allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
            // agregamos el balance de tokens al buyer
            balances[buyer] = balances[buyer].add(numTokens);
            
            //emitimos el evento Transfer para toda la red
            emit Transfer(owner, buyer, numTokens);
            
            return true;
        }

}
