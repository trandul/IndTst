//1. Дана JSON строка '["Коля", "Вася", "Петя"]'. Преобразуйте ее в массив JavaScript и выведите на экран элемент "Петя".
let namesString = '["Коля", "Вася", "Петя"]';
let arr = JSON.parse(namesString);
console.log(arr[2]);
//2. Выведите на экран (document.write) с помощью циклов JavaScript строку '111222333444555666777888999'
<!DOCTYPE html>
<html>
    <head>
    </head>
    <body>
        <script type="text/javascript">
			let number = 1;
			while (number<=9){
				let idx = 1;
				while (idx<=3){
					document.write(number);
					idx++;
				}
				number++;
			}
        </script>
    </body>
</html>
//3. Напишите код JavaScript который выводит алертом содержимое поля ввода, возведенное в квадрат
<!DOCTYPE html>
<html>
    <head>
    </head>
    <body>
	<button id="button" onclick='processNumber()'>Нажми на меня!</button>
	<input id="number" placeholder = 'Введите число!' type="text" pattern="\\d+"></input>
        <script type="text/javascript">
		function processNumber(){
			let inpStr = document.getElementById('number').value;
			alert(isFinite(inpStr)?Math.pow(parseInt(inpStr),2):'Введите число');
        </script>
    </body>
</html>
