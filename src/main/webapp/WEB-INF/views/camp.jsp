<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>YEEEEEEEEEEEEEEEEEEEEEE</title>
<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
<style>
	#now{background:skyblue; width:400px; height:30px; margin:10px; padding:5px;}
</style>
</head>
<body>
	<h1>날씨목록</h1>
	<div id="now">
		<span id="date"></span>
		<span id="weather"></span>
	</div>
	<table id="tbl" width=700 border=1></table>
	<script id="temp" type="text/x-handlebars-templete">
	<tr>
		<td>지역</td>
		<td>날씨</td>
		<td>기온</td>
		<td>풍속</td>
		<td>습도</td>
	</tr>
	{{#each .}}
		<tr>
			<td>{{region}}</td>
			<td>{{condition}}</td>
			<td>{{temp}}</td>
			<td>{{wind}}</td>
			<td>{{humid}}</td>
		</tr>
	{{/each}}
	</script>
</body>
<script>
getListw();
function getListw(){
	$.ajax({
		type:"get",
		url:"weather.json",
		dataType:"json",
		success:function(data){
			var temp=Handlebars.compile($("#temp").html());
			$("#tbl").html(temp(data));
		}
	});
}
var weather=[]; //반복되는 날씨 데이터를 저장할 배열
getdata();
function getdata(){
	$.ajax({
		type:"get",
		url:"now.json",
		dataType:"json",
		success:function(data){
			$("#date").html(data.date); //날짜 고정
			
			var i = 0;
			$(data.list).each(function(){ //data의 list에 있는 값들을 반복시킴
				weather[i] = this.region + "   "+ this.condition + "   "+ this.temper+ this.icon; 
				i++;
			});
			i = 0;
			var interval = setInterval(function(){ //간격을 두고 계속 실행하는 명령문
				$("#weather").html(weather[i]); 
				if(i < weather.length-1 ){
					i++;	
				}else{
					i =0 ;
				}
			},1000); //1초 간격으로 계속 반복문 실행
		}
	});
}
</script>
</html>