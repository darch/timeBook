/**
 * リスト画面から、入力画面への遷移するためのメソッド
 */
function goto_Input(day){
	myForm = document.forms["goto_input"];
	myForm.day.value = day;
	myForm.action = "input.cgi";
	myForm.method = "POST";
	myForm.submit();
	return false;
}

/**
 * 入力画面から、リスト画面に遷移するためのメソッド
 */
function goto_List(myCommand){
	myForm = document.forms["gotoList"];
	myForm.command.value = myCommand;
	startTime = myForm.start.value;
	endTime = myForm.end.value;
	if (myCommand == "submit"){
		if (checkTime(startTime) == false){
			alert(startTime + " is invalied");
			myForm.start.focus();
		} else if (checkTime(endTime) == false){
			alert(endTime + " is invalied");
			myForm.end.focus();
		} else {
			myForm.action = "list.cgi";
			myForm.method = "POST";
			myForm.submit();
		}
	} else if (myCommand == "revert"){
		myForm.action = "list.cgi";
		myForm.method = "POST";
		myForm.submit();
	}
	return false;
}

/**
 * startとendの入力値が正しいか判定するためのメソッド
 */
function checkTime(input){
	if (input.match(/^[0-9]{4}$/) != null){
		// 入力値が数字で、桁数が４桁の場合
		// 入力値を分割して、時と分にに分ける
		// 数値の大きさでエラー判定をするため、
		// 文字列型から数値型に変換する。
		hour = parseInt(input.substring(0, 2));
		min = parseInt(input.substring(2, 4));

		if (hour <= 32 && min <= 59){
			// 時間が32未満の場合
			// かつ、分が59未満の場合
			// 時間はフレックスがないため、8時には始まる。
			// 1日働いても32時までで一周する。
			return true;
		}
	} else if (input == ""){
		// 入力値が空文字の場合
		return true;
	}
	return false;
}

