<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title></title>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=64f12bd2c35c20c0219891a95fe41693"></script>
	<link href="${pageContext.request.contextPath}/resources/camp.css" rel="stylesheet">
	<style>
	h1{margin:30px}
	#map{
		display:none;
	}
	
	#bid{
		display:none;
	}
	
#dark {
	position: absolute;
	top: 0px;
	left: 0px;
	right: 0px;
	height: 100%;
	width: 100%;
	background: rgba(0, 0, 0, 0.5);
	z-index: 1000;
	overflow-y: scroll;
	display: none;
}

#lightbox {
	width: 700px;
	margin: 20px auto;
	padding: 15px;
	border: 1px solid #333333;
	border-radius: 5px;
	background: white;
	box-shadow: 0px 5px 5px rgba(34, 25, 25, 0.4);
	text-align: center;
	overflow:hidden;
}
</style>
</head>
<body>
<div id="page">
	<h1>내 캠핑장</h1>
	<button onClick="location.href='campjsp'" style="margin-bottom:30px">home</button>
	<!-- 캠핑테이블 -->
	<table border=1 width="700" id="tbl-camp" style="margin:0px auto;"></table>
	<script id="tempc" type="text/x-handlebars-template">
			{{#each list}}
			<tr>
				<td class=id width=50>{{id}}</td>
				<td width=200>{{title}}</td>
				<td width=200>{{address}}</td>
				<td width=150>{{phone}}</td>
				<td width=50><button class=btnread>수정</button></td>
				<td width=50><button class=btndel>삭제</button></td>
			</tr>
			{{/each}}
			</script>
			
	<div id="pagination" style="margin-left:50px;"></div>

	<div id="dark">
		<div id="lightbox">
			<div id="localbtn">
				<button>서울</button>
				<button>경기</button>
				<button>강원도</button>
				<button>충청도</button>
				<button>경상도</button>
				<button>울릉도</button>
				<button>전라도</button>
				<button>제주</button>
				<br>
				<span id=bid></span>
				<input type="text" id="query" size=50 value="${param.query}">
				<input type="button" id="search" value="검색"> 검색수 : <span
					id=total></span>건
			</div>
			<table id=tbl border=1 width=700></table>
			<script id="temp" type="text/x-handlebars-template">
			{{#each documents}}
				<tr class=row>
					<td width=150 class=place_name><div>{{place_name}}</div></td>
					<td width=150 class=phone>{{phone}}</td>
					<td width=300 class="road_address_name">{{road_address_name}}</td>
					<td width=100><button class="map" x="{{x}}" y="{{y}}" tel="{{phone}}" style="width:100%" place="{{place_name}}">지도보기</button></td>
					<td width=100><button class=btnup>변경하기</button></td>
				</tr>
			{{/each}}
			</script>
			<button id=btnmore>더보기</button>
			<button id="btnClose">닫기</button>
			<div id="map" style="width: 700px; height: 550px; background: gray; float: left;"></div>
		</div>
	</div>
</div>
</body>
	<script>
		var page = 1;
		var page2 = 1;
		var is_end2=false;
		var query=$("#query").val();
		var localQuery="";
		
		getlistc();
		
		//지도출력
		$("#tbl").on("click", "tr .map", function() {
			$("#map").show();
		});
		
		//버튼마다 지역 검색
		$("#localbtn").on("click", "button", function() {
			$("#query").val("");
			query = $("#query").val();
			localQuery = $(this).html();
			$("#tbl").html("");
			page = 1;
			getlist();
			//alert(localQuery);
		});
		
		//리스트
		function getlist() {
			$.ajax({
				type : "get",
				url : "https://dapi.kakao.com/v2/local/search/keyword.json",
				headers : {
					"Authorization" : "KakaoAK 64f12bd2c35c20c0219891a95fe41693"
				},
				data : {
					"query" : localQuery + query + "캠핑장",
					"page" : page,
					"size" : "5"
				},
				success : function(data) {
					var temp = Handlebars.compile($("#temp").html());
					$("#tbl").append(temp(data));
					$("#total").html(data.meta.total_count);
				}
			});
		}
		
		//다크박스 띄우기
		$("#tbl-camp").on("click","tr .btnread",function(){
			var row = $(this).parent().parent();
			var id = row.find(".id").html();
			page=1;
			
			$("#bid").html(id);
			$("#dark").show();
			$("#tbl").html("");
			
			getlist();
			
		});
		
		//다크박스 닫기
		$("#btnClose").on("click",function(){
			$("#map").hide();
			$("#dark").hide();
			
			getlistc();
		});
		
		//삭제
		$("#tbl-camp").on("click","tr .btndel",function(){
			var row = $(this).parent().parent();
			var id = row.find(".id").html();
			$.ajax({
				type : "get",
				url : "delete",
				data : {"id" : id},
				success : function(data) {
					alert("삭제했어");
					getlistc();
				}

			});
		});
		
		//변경
		$("#tbl").on("click","tr .btnup",function(){
			var row = $(this).parent().parent();
			var id = $("#bid").html();
			var title = row.find(".place_name").html();
			var phone = row.find(".phone").html();
			var address = row.find(".road_address_name").html();

			$.ajax({
				type : "get",
				url : "update",
				data : {"id":id, "title":title, "phone":phone, "address":address},
				success : function(data) {
					alert("변경했어");
					
					$("#map").hide();
					$("#dark").hide();
					
					getlistc();
				}

			}); 
		});
		
		
		
		//검색
		$("#btnsearch").on("click", function(){
			$("#tbl-camp").html("");
			query = $("#query").val();
			page = 1;
			getlist();
		});

		//키다운 검색
		$("#query").keydown(function(key){
			if(key.keyCode==13){
				$("#tbl-camp").html("");
				query = $("#query").val();
				page = 1;
				getlist();
			}
		});
		
		//지도보기
		$("#tbl").on("click","tr .map", function(){
			$("#dark").show();
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
			
		});
		
		//더보기
		$("#btnmore").on("click", function(){
			page += 1;
			getlist();
		});
		
		//내캠핑장 목록
		function getlistc() {
			$.ajax({
				type : "get",
				url : "camp.json",
				dataType : "json",
				data : {"page" : page2},
				success : function(data) {
					var temp = Handlebars.compile($("#tempc").html());
					$("#tbl-camp").html(temp(data));
					var str = "";

					if (data.pm.prev) {
						str += "<a href='" + (data.pm.startPage - 1) + "'>"
								+ "◀</a>";
					}
					for (var i = data.pm.startPage; i <= data.pm.endPage; i++) {
						str += "<a href='" + i + "'>" + i + " </a> ";
					}
					if (data.pm.next) {
						str += "<a href='" + (data.pm.endPage + 1) + "'>"
								+ "▶</a>";
					}
					$("#pagination").html(str);
				}

			});
		}

		//캠프 테이블 페이지 이동
		$("#pagination").on("click", "a", function(e) {
			e.preventDefault();
			page2 = $(this).attr("href");
			getlistc();

		});
	</script>
</html>