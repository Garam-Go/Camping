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
		Elements el = doc.select("#content .tbl_weather tbody"); //table�� tbody�� �ҷ���
		ArrayList<WeatherVO> array = new ArrayList<WeatherVO>();
		for(Element e:el.select("tr")){ //tr�ݺ�
			WeatherVO vo = new WeatherVO();
			
			vo.setRegion(e.select("th").text()); 
			vo.setWcondition(e.select(".line ul .nm").text());
			//vo.setIcon(e.select("td:nth-child(2) img.attr('src')").text());
			vo.setLowtemp(e.select("td:not(.line) ul .temp").text());
			vo.setMhumid(e.select("td:not(.line) .text .rain").html()); //����Ȯ��
			vo.setHightemp(e.select(".line .text .temp").text());
			vo.setAhumid(e.select(".line .text .rain").html()); //����Ȯ��
			array.add(vo);
		}
		hash.put("list", array);
		return hash;
	}
	//DB�� ���� ����ֱ�
	@ResponseBody
	@RequestMapping(value="winsert", method=RequestMethod.POST)
	public void winsert(WeatherVO vo) throws Exception{
		System.out.println(vo.toString());
		dao.winsert(vo);
	}
	
	//DB���� ����
	@ResponseBody
	@RequestMapping("rweather.json")
	 public HashMap<String, Object> list(WeatherVO vo) throws Exception{
		HashMap<String, Object> hash = new HashMap<String, Object>();
	    hash.put("list", dao.list(vo));
	   return hash;
	}
	
	//���� Ȩ�������� �ǽð� ����
	@ResponseBody
	@RequestMapping("now.json") //���� �ǽð�����
	public HashMap<String, Object> now()throws Exception{
		HashMap<String, Object> array = new HashMap<String, Object>(); //��ü ���������Ͱ� �� hashmap�ۼ�
		Document doc = Jsoup.connect("http://www.daum.net").get();
		Elements es = doc.select(".info_today");
		array.put("date", es.select(".date_today").text()); //���糯¥ ����(�������� ������)
		
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(); //�ݺ��Ǵ� �����͸� ����� array ����
		for(Element e:es.select("li")){
			HashMap<String, Object> hash = new HashMap<String, Object>(); //hashmap���� ������ ������ ����
			hash.put("region", e.select(".txt_part").text());
			hash.put("condition", e.select(".ico_ws").text());
			hash.put("temper", e.select(".txt_temper").text());
			hash.put("icon", e.select(".ir_wa").text());
			list.add(hash);
		}
		array.put("list", list);//�ݺ��Ǵ� ������ arraylist�� ��ü hashmap�� ��������
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
