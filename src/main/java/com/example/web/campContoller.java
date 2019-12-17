package com.example.web;

import java.util.ArrayList;
import java.util.HashMap;

import javax.inject.Inject;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.domain.CampVO;
import com.example.domain.Criteria;
import com.example.domain.PageMaker;
import com.example.domain.WeatherVO;
import com.example.persistence.CampDAO;
import com.example.persistence.WeatherDAO;

@Controller
public class campContoller {
	@Inject
	WeatherDAO dao;
	
	@Inject
	CampDAO cdao;
	
	@RequestMapping("camp")
	public String camp(){
		return "camp";
	}
	
	@RequestMapping("campjsp")
	public String campjsp(){
		return "campjsp";
	}
	
	@RequestMapping("maps")
	public String maps(){
		return "maps";
	}
	
	@ResponseBody
	@RequestMapping("weather.json")
	public HashMap<String, Object> weather() throws Exception{
		HashMap<String, Object> hash = new HashMap<String, Object>();
		Document doc = Jsoup.connect("https://weather.naver.com/rgn/cityWetrMain.nhn").get();
		hash.put("date", doc.select("#header .lnb .lnb_date:not(.blind)").text());
		Elements el = doc.select("#content .tbl_weather tbody"); //table의 tbody를 불러옴
		ArrayList<WeatherVO> array = new ArrayList<WeatherVO>();
		for(Element e:el.select("tr")){ //tr반복
			WeatherVO vo = new WeatherVO();
			
			vo.setRegion(e.select("th").text()); 
			vo.setWcondition(e.select(".line ul .nm").text());
			//vo.setIcon(e.select("td:nth-child(2) img.attr('src')").text());
			vo.setLowtemp(e.select("td:not(.line) ul .temp").text());
			vo.setMhumid(e.select("td:not(.line) .text .rain").html()); //강수확률
			vo.setHightemp(e.select(".line .text .temp").text());
			vo.setAhumid(e.select(".line .text .rain").html()); //강수확률
			array.add(vo);
		}
		hash.put("list", array);
		return hash;
	}
	//DB에 날씨 집어넣기
	@ResponseBody
	@RequestMapping(value="winsert", method=RequestMethod.POST)
	public void winsert(WeatherVO vo) throws Exception{
		System.out.println(vo.toString());
		dao.winsert(vo);
	}
	
	//DB날씨 띄우기
	@ResponseBody
	@RequestMapping("rweather.json")
	 public HashMap<String, Object> list(WeatherVO vo) throws Exception{
		HashMap<String, Object> hash = new HashMap<String, Object>();
	    hash.put("list", dao.list(vo));
	   return hash;
	}
	
	//다음 홈페이지의 실시간 날씨
	@ResponseBody
	@RequestMapping("now.json") //다음 실시간날씨
	public HashMap<String, Object> now()throws Exception{
		HashMap<String, Object> array = new HashMap<String, Object>(); //전체 날씨데이터가 들어갈 hashmap작성
		Document doc = Jsoup.connect("http://www.daum.net").get();
		Elements es = doc.select(".info_today");
		array.put("date", es.select(".date_today").text()); //현재날짜 저장(날씨들의 고정값)
		
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(); //반복되는 데이터를 담아줄 array 생성
		for(Element e:es.select("li")){
			HashMap<String, Object> hash = new HashMap<String, Object>(); //hashmap으로 저장할 데이터 생성
			hash.put("region", e.select(".txt_part").text());
			hash.put("condition", e.select(".ico_ws").text());
			hash.put("temper", e.select(".txt_temper").text());
			hash.put("icon", e.select(".ir_wa").text());
			list.add(hash);
		}
		array.put("list", list);//반복되는 데이터 arraylist를 전체 hashmap에 저장해줌
		return array;
	}
	@ResponseBody
	@RequestMapping("camp.json")
	 public HashMap<String, Object> list(Criteria cri) throws Exception{
	        cri.setPerPageNum(10);
	         
	        PageMaker pm=new PageMaker();
	        pm.setCri(cri);
	        pm.setTotalCount(cdao.total());
	         
	        HashMap<String, Object> map=new HashMap<String, Object>();
	        map.put("list", cdao.list(cri));
	        map.put("pm",pm);
	        return map;
	}
	
	@RequestMapping("scamp")
	public String scampjsp(String qyery){
		return "scamp";
	}
	
	@ResponseBody
	@RequestMapping("insert")
	public void insert(CampVO vo) throws Exception{
		System.out.println(vo.toString());
		cdao.insert(vo);
	}
	
	@ResponseBody
	@RequestMapping("update")
	public void update(CampVO vo) throws Exception{
		cdao.update(vo);
	}
	
	@ResponseBody
	@RequestMapping("delete")
	public void delete(int id) throws Exception{
		cdao.delete(id);
	}
}
