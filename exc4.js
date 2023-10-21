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
// нужно ли сообщение в случае, если введено нечисловое значение?
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
		}
        </script>
    </body>
</html>
//4. Написать функцию для кнопки (id=”buttonAdd”) которая добавляет новую строчку к таблице (id=”memberTable”) с пустыми полями имя и фамилия (тип полей input), но заполненным полем № п\п (тоже тип input ,но недоступен для редактирования).
//Начальные строки создать программно или как html или нет разницы?
<!DOCTYPE html>
<html>
    <head>
    </head>
    <body>
	<table id = "table">
            <tr>
                <th>№ п\п</th>
                <th>Имя</th>
                <th>Фамилия</th>
            </tr>
            <tr>
                <td>1</td>
                <td>Иван</td>
                <td>Пётр</td>
            </tr>
            <tr>
                <td>2</td>
                <td>Иванов</td>
                <td>Петров</td>
            </tr>
        </table>
	<button id="addButton" onclick='addRow()'>Добавить строку</button>
        <script type="text/javascript">
		var idx = 3;
		function addRow(){
			let table = document.getElementById('table');
			table.insertAdjacentHTML('beforeend', '<tr><td><input readonly value = "'+idx+'" size = 4/></td> <td><input placeholder = "Имя"></input></td> <td><input placeholder = "Фамилия"></input></td> </tr>')
			idx++;
		}
        </script>
    </body>
</html>
//5. Написать функцию для кнопки валидации данных (id=”validButton”), которая проверяет наличие пустых полней из таблицы ( задания 4 ) и если поля заполнены, то проверяет кол-во введенных символов ( >= 2). 
//При успешной валидации выводит на экран алерт: «Успешно». Иначе «Не выполнены все условия заполнения таблицы».
<!DOCTYPE html>
<html>
    <head>
    </head>
    <body>
	<table id = "table">
            <tr>
                <th>№ п\п</th>
                <th>Имя</th>
                <th>Фамилия</th>
            </tr>
            <tr>
                <td>1</td>
                <td>Иван</td>
                <td>Пётр</td>
            </tr>
            <tr>
                <td>2</td>
                <td>Иванов</td>
                <td>Петров</td>
            </tr>
        </table>
	<button id="addButton" onclick='addRow()'>Добавить строку</button>
	<button id="validateButton" onclick='validate()'>Валидация</button>
        <script type="text/javascript">
		var idx = 3;
		function addRow(){
			let table = document.getElementById('table');
			table.insertAdjacentHTML('beforeend', '<tr><td><input readonly value = "'+idx+'" size = 4 class = "idx"/></td> <td><input placeholder = "Имя"></input></td> <td><input placeholder = "Фамилия"></input></td> </tr>')
			idx++;
		}
		function validate(){
			let inputs = Array.prototype.slice.call(document.getElementsByTagName('input'),0);
			inputs.length>0?alert(inputs.filter(x=>(x.className !='idx' && x.value.length<2)).length>0?"Не выполнены все условия заполнения таблицы":"Успешно"):null;
		}
        </script>
    </body>
</html>
