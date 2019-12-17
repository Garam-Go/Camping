<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="initial-scale=1, maximum-scale=1" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>캠핑장목록</title>
<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=64f12bd2c35c20c0219891a95fe41693"></script>
	<link href="${pageContext.request.contextPath}/resources/camp.css" rel="stylesheet">
</head>
<body>
	<div id="page">
		<div id="now">
			<span id="date"></span> <span id="weather"></span>
		</div>
		<h1>제목</h1>
		<div id="localbtn">
			<button>서울</button>
			<button>경기</button>
			<button>강원</button>
			<button>충청</button>
			<button>경상</button>
			<button>울릉</button>
			<button>전라</button>
			<button>제주</button>
			<br> <input type="text" id="query" size=50 value="인천"> <input
				type="button" id="search" value="검색"> 검색수 : <span id=total></span>건
		</div>
		<div style="position: relative;">
			<span style="margin-right: 550px;"> <input type="checkbox"
				id="chkAll"> <input type="button" value="저장" id="btnSave">
			</span> <span> <input type="button" class="b" value="내캠핑장"
				onClick="funscamp()">
			</span>
		</div>
		<table id=tbl border=1 width=700></table>
		<script id="temp" type="text/x-handlebars-template">
		{{#each documents}}
			<tr class=row>
				<td><input type="checkbox" place_name="{{place_name}}" phone="{{phone}}" road_address_name="{{road_address_name}}"></td>
				<td width=150>{{place_name}}</td>
				<td width=150>{{phone}}</td>
				<td width=300>{{road_address_name}}</td>
				<td width=100><button class="b" x="{{x}}" y="{{y}}" tel="{{phone}}" style="width:100%" place="{{place_name}}">지도보기</button></td>
			</tr>
		{{/each}}
	</script>
		<button id=btnmore>더보기</button>
		<h1>날씨목록</h1>
		<span id="todayDate"></span>
		<table id="tblw" width=700 border=1></table>
		<script id="tempw" type="text/x-handlebars-templete">
	<tr>
		<td>지역</td>
		<td>날씨</td>
		<td>최저기온</td>
		<td>최고기온</td>
		<td>오전강수확률</td>
		<td>오후강수확률</td>
	</tr>
	{{#each list}}
		<tr class="dd" >
			<td class="region" region="{{region}}">{{region}}</td>
			<td class="wcondition">{{wcondition}}</td>
			<td class="low">{{lowtemp}}</td>
			<td class="high">{{hightemp}}</td>
			<td class="mhumid">{{{mhumid}}}</td>
			<td class="ahumid">{{{ahumid}}}</td>
		</tr>
	{{/each}}
	</script>
		<!-- 	버튼누르면 값 비교해서 날씨 띄우기 -->
		<script>
		//날짜 바뀌면 날씨 저장하기
		$("#todayDate").on("DOMSubtreeModified",function(){
			var date = $("#todayDate").html();
			$("#tblw tr .region").each(function(){
				var row = $(this).parent();
				var region = row.find(".region").html();
				var hightemp = row.find(".high").html();
				var lowtemp = row.find(".low").html();
				var wcondition = row.find(".wcondition").html();
				var mhumid = row.find(".mhumid strong").html();
				var ahumid = row.find(".ahumid strong").html();
				
				//alert(date +"/"+ region +"/"+ highTemp+"/"+lowTemp+"/"+wcondition+"/"+mhumid+"/"+ahumid);
				$.ajax({
					type:"post",
					url:"winsert",
					data:{"date":date, "region":region,"hightemp":hightemp,"lowtemp":lowtemp,"wcondition":wcondition,"mhumid":mhumid,"ahumid":ahumid},
					success:function(){
					}
				});
			});
		});
	
		//버튼 누르면 거기에 맞는 날씨 띄우기
		
		</script>
	</div>
	<!-- 라이트박스 -->
	<div id="dark">
		<div id="lightbox">
			<div id="map"	style="width: 600px; height: 550px; background: gray; float: left;"></div>
			<div id="weather"	style="background: gold; margin-left: 20px; width: 200px; height: 500px; float: left;">
				<span id="now"></span> <br>
				<table id="tblrw" width=200 border=1></table>
		<script id="temprw" type="text/x-handlebars-templete">
	{{#each list}}
		<tr>
			<td>지역</td>
			<td class="region" region="{{region}}">{{region}}</td>
		</tr>
		<tr>
			<td>날씨</td>
			<td class="wcondition">{{wcondition}}</td>
		</tr>
		<tr>
			<td>최저기온</td>
			<td class="low">{{lowtemp}}</td>
		</tr>
		<tr>
			<td>최고기온</td>
			<td class="high">{{hightemp}}</td>
		</tr>
		<tr>
			<td>오전강수확률</td>
			<td class="mhumid">{{{mhumid}}}</td>
		</tr>
		<tr>
			<td>오후강수확률</td>
			<td class="ahumid">{{{ahumid}}}</td>
		</tr>
	{{/each}}
	</script>
			</div>
			<br> <a id="btnClose" href="#">X</a>
			<button id="blog-show" style="margin-top: 20px;">관련 포스팅 보기</button>
			<div id="blog" style="margin-top: 30px;">
				<table id=tbl1 border=1 width=700 style="margin: 0 auto"></table>
				<script id="temp1" type="text/x-handlebars-template">
				{{#each documents}}
					<tr class=row>
						<td width=150><div class="blog">{{{blogname}}}</div></td>
						<td width=550><div class="title"><a href="{{url}}">{{{title}}}</a></div></td>
					</tr>
				{{/each}}
			</script>
				<br>
				<div>
					<button id=btnprev>이전</button>
					<button id=btnnext>다음</button>
				</div>
			</div>
			<!-- blog div -->
		</div>
	</div>
</body>
<script>
	var query = $("#query").val();
	var start = 1;
	var page = 1;
	var page1 = 1;
	var query1 = "";
	var localQuery = "";
	//scamp갈때 query 가져가기
	function funscamp() {
		var scampQuery = localQuery + query + "캠핑장";
		location.href = "scamp?query=" + scampQuery;
	}

	//chkAll버튼을 누르면  checkbox 전체가 눌림
	$("#chkAll").on("click", function() {
		if ($(this).is(":checked")) {
			$("#tbl .row input:checkbox").on("click", function() {
				$("#chkAll").prop("checked", false);
			});
			$("#tbl .row input:checkbox").each(function() {
				$(this).prop("checked", true);
				//checkbox 모두 체크
			});
		} else {
			$("#tbl .row input:checkbox").each(function() {
				$(this).prop("checked", false);
			});
		}
	});

	//체크저장
	$("#btnSave").on("click", function() {
		if (!confirm("저장하시겠습니까?"))
			return;

		if ($("#tbl .row input:checkbox:checked").length == 0) {
			alert("하나 이상 체크해주세요");
			return;
		}
		$("#tbl .row input:checkbox:checked").each(function() {
			var place_name = $(this).attr("place_name");
			var phone = $(this).attr("phone");
			var road_address_name = $(this).attr("road_address_name");
			//alert(place_name +" -"+phone +" -"+road_address_name);
			$.ajax({
				type : "get",
				url : "insert",
				data : {
					"title" : place_name,
					"phone" : phone,
					"address" : road_address_name
				},
				success : function() {
					//alert("성공");	
				}
			});
			$(this).prop("checked", false);
		});
		if (confirm("저장되었습니다. 저장한 페이지로 넘어가시겠습니까?")) {
			getlist();
			location.href = "scamp?query=" + localQuery + query + "캠핑장";
		} else {
			$("#chkAll").prop("checked", false);
		}

	});

	/*
	 * 
	 if(confirm("저장되었습니다. 저장한 페이지로 넘어가시겠습니까?")){
			location.href="scamp";
		}
	 */
	//tbl-camp  라이트박스 닫기
	$("#btnMyCamp").on("click", function() {
		$("#dark2").show();
	});
	//tbl-camp  라이트박스 닫기
	$("#btnClose2").on("click", function() {
		$("#dark2").hide();
	});

	getlist();
	getListw();
	//날씨리스트
	function getListw() {
		$.ajax({
			type : "get",
			url : "weather.json",
			dataType : "json",
			success : function(data) {
				var temp = Handlebars.compile($("#tempw").html());
				$("#tblw").html(temp(data));

				$("#todayDate").html(data.date);
			}
		});
	}
	
	//버튼누르면 맞는 날씨 띄우기
	$("#localbtn").on("click","button",function(){
		var date = $("#todayDate").html();
		var region = $(this).html();
		//alert(date+region);
		$.ajax({
			type : "get",
			url : "rweather.json",
			dataType:"json",
			data:{"date":date, "region":region},
			success : function(data) {
				var temp = Handlebars.compile($("#tempw").html());
				$("#tblw").html(temp(data));
				
				$("#todayDate").html(data.date);
			}
		});
	})
	var weather = []; //반복되는 날씨 데이터를 저장할 배열
	//실시간 반복날씨
	getdata();
	function getdata() {
		$.ajax({
			type : "get",
			url : "now.json",
			dataType : "json",
			success : function(data) {
				$("#date").html(data.date); //날짜 고정

				var i = 0;
				$(data.list).each(
						function() { //data의 list에 있는 값들을 반복시킴
							weather[i] = this.region + "   " + this.condition
									+ "   " + this.temper + this.icon;
							i++;
						});
				i = 0;
				var interval = setInterval(function() { //간격을 두고 계속 실행하는 명령문
					$("#weather").html(weather[i]);
					if (i < weather.length - 1) {
						i++;
					} else {
						i = 0;
					}
				}, 100); //1초 간격으로 계속 반복문 실행
			}
		});
	}
	//블로그 이전 다음버튼
	$("#btnnext").on("click", function() {
		if (!is_end) {
			page1 += 1;
			getblog();
		}
	});
	$("#btnprev").on("click", function() {
		if (page1 > 1) {
			page1 -= 1;
			getblog();
		}
	});

	//블로그리스트
	function getblog() {
		$.ajax({
			type : "get",
			url : "https://dapi.kakao.com/v2/search/blog",
			headers : {
				"Authorization" : "KakaoAK 64f12bd2c35c20c0219891a95fe41693"
			},
			data : {
				"query" : query1,
				"page" : page1,
				"size" : "5"
			},
			success : function(data) {
				var temp = Handlebars.compile($("#temp1").html());
				$("#tbl1").html(temp(data));
				is_end = data.meta.is_end;
			}
		});
	}

	//검색
	$("#btnsearch").on("click", function() {
		$("#tbl").html("");
		query = $("#query").val();
		page = 1;
		getlist();
	});

	//키다운 검색
	$("#query").keydown(function(key) {
		if (key.keyCode == 13) {
			$("#tbl").html("");
			query = $("#query").val();
			page = 1;
			getlist();
		}
	});

	//캠핑장 리스트
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
				//if(data.documents.road_address_name)  localQuery에 들어간 지역이 지역명에 겹치는 것만 띄우게 하기. 나중에
			}
		});
	}
	//더보기
	$("#btnmore").on("click", function() {
		page += 1;
		getlist();
	});
	//지도보기
	$("#tbl").on("click", ".row button", function() {
		$("#dark").show();
		var x = $(this).attr("x");
		var y = $(this).attr("y");
		var tel = $(this).attr("tel");

		var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
		var options = { //지도를 생성할 때 필요한 기본 옵션
			center : new kakao.maps.LatLng(y, x), //지도의 중심좌표.
			level : 3
		//지도의 레벨(확대, 축소 정도)
		};

		var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴

		var marker = new kakao.maps.Marker({
			position : new kakao.maps.LatLng(y, x)
		});
		marker.setMap(map);

		var info = new kakao.maps.InfoWindow({
			content : "<center>전화 : " + tel + "</center>"
		});

		kakao.maps.event.addListener(marker, "mouseover", function() {
			info.open(map, marker);
		});

		kakao.maps.event.addListener(marker, "mouseout", function() {
			info.close(map, marker);
		});
		//날씨 가져오기
		var date = $("#todayDate").html();
		var region = $("#tblw tr .region").html();
		$.ajax({
			type : "get",
			url : "rweather.json",
			dataType:"json",
			data:{"date":date, "region":region},
			success : function(data) {
				var temp = Handlebars.compile($("#temprw").html());
				$("#tblrw").html(temp(data));
				
				$("#now").html(data.date);
			}
		});
		//블로그띄우는거 가져오기
		query1 = $(this).attr("place");

		getblog();
	});
	//lightbox
	$("#btnClose").on("click", function() {
		$("#dark").hide();
// 		window.location.reload();
	});
	//lb닫기
	$("#blog-show").on("click", function() {
		$("#blog").show();
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
</script>
</html>