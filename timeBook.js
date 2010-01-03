function submit(day){
	myForm = document.forms["goto_input"];
	myForm.day.value = day;
	myForm.action="input.cgi";
	myForm.method="POST";
	myForm.submit();
}
