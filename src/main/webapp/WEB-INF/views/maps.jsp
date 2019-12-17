<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>캠핑장</title>
<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
<script	src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=864fdbe508ad54d91099aadd9251ff07"></script>
<link rel="stylesheet" href="resources/style.css">
</head>
<body>
	<h1>캠핑</h1>
	검색 : <input type=text id=query value="캠핑장">
		<input type=button id=btnsearch value="검색">
		검색수 : <span id=total></span> 건
	<table id=tbl border=1 width=700></table>
	<script id="temp" type="text/x-handlebars-template">
		{{#each documents}}
			<tr class=row>
				<td width=200>{{place_name}}</td>
				<td width=100>{{phone}}</td>
				<td width=300>{{road_address_name}}</td>
				<td width=100><button x="{{x}}" y="{{y}}" tel="{{phone}}" style="width:100%" place="{{place_name}}">지도보기</button></td>
			</tr>
		{{/each}}
	</script>
	<button id=btnmore>더보기</button>
	
	<div id=darkbox>
		<div id=lightbox>
			<div style="text-align:right;">
				<input id=close type=button value="x" >
			</div>
			<div id=map style="width:700px; height:500px; background:gray; margin:0 auto"></div>
			
			
			<table id=tbl1 border=1 width=700 style="margin:0 auto"></table>
			<script id="temp1" type="text/x-handlebars-template">
				{{#each documents}}
					<tr class=row>
						<td width=150><div class="blog">{{{blogname}}}</div></td>
						<td width=550><div class="title"><a href="{{url}}">{{{title}}}</a></div></td>
					</tr>
				{{/each}}
			</script>
			
			<div>
				<button id=btnprev>이전</button>
				<button id=btnnext>다음</button>
			</div>
	
		<!-- <iframe id="iframe" width=1024 height=1200></iframe> -->
		</div>
	</div>
	
</body>
	<script>
	var query = $("#query").val();
	var query1 = "";
	var page = 1;
	var page1 = 1;
	var is_end;
	
	getlist();
	//blog버튼
	$("#btnnext").on("click", function(){
		if(!is_end){
			page1 += 1;
			getblog();
		}
	});
	$("#btnprev").on("click", function(){
		if(page1 > 1){
			page1 -= 1;
			getblog();
		}
	});
	
	//블로그리스트
	function getblog(){
		$.ajax({
			type:"get",
			url:"https://dapi.kakao.com/v2/search/blog",
			headers:{"Authorization": "KakaoAK 864fdbe508ad54d91099aadd9251ff07"},
			data:{"query":query1, "page":page1, "size":"5"},
			success:function(data){
				var temp = Handlebars.compile($("#temp1").html());
				$("#tbl1").html(temp(data));
				is_end=data.meta.is_end;
			}
		});
	}
	
	//지도보기
	$("#tbl").on("click",".row button", function(){
		$("#darkbox").show();
		var x =$(this).attr("x");
		var y =$(this).attr("y");
		var tel =$(this).attr("tel");
		
		var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
		var options = { //지도를 생성할 때 필요한 기본 옵션
			center: new kakao.maps.LatLng(y, x), //지도의 중심좌표.
			level: 3 //지도의 레벨(확대, 축소 정도)
		};

		var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
		
		var marker = new kakao.maps.Marker({
			position:new kakao.maps.LatLng(y, x)
		});
		marker.setMap(map);
		
		var info=new kakao.maps.InfoWindow({
			content: "<center>전화 : "+tel+"</center>"
		});
		
		kakao.maps.event.addListener(marker, "mouseover", function(){
			info.open(map,marker);
		});
		
		kakao.maps.event.addListener(marker, "mouseout", function(){
			info.close(map,marker);
		});
		
		query1=$(this).attr("place");
		
		getblog();
	});
	
	//더보기
	$("#btnmore").on("click", function(){
		page += 1;
		getlist();
	});
	
	//지도닫기
	$("#close").on("click", function(){
		$("#darkbox").hide();
	});
	
	
	
	//검색
	$("#btnsearch").on("click", function(){
		$("#tbl").html("");
		query = $("#query").val();
		page = 1;
		getlist();
	});
	
	//키다운 검색
	$("#query").keydown(function(key){
		if(key.keyCode==13){
			$("#tbl").html("");
			query = $("#query").val();
			page = 1;
			getlist();
		}
	});
	
	//리스트
	function getlist(){
		$.ajax({
			type:"get",
			url:"https://dapi.kakao.com/v2/local/search/keyword.json",
			headers:{"Authorization": "KakaoAK 864fdbe508ad54d91099aadd9251ff07"},
			data:{"query":query, "page":page, "size":"5"},
			success:function(data){
				var temp = Handlebars.compile($("#temp").html());
				$("#tbl").append(temp(data));
				$("#total").html(data.meta.total_count);
				
			}
		});
	}
	
	
	
	</script>
</html>