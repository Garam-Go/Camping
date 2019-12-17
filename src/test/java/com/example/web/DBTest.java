package com.example.web;

import javax.inject.Inject;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.example.domain.WeatherVO;
import com.example.persistence.WeatherDAO;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"file:src/main/webapp/WEB-INF/spring/**/*.xml"})
public class DBTest {
	@Inject
	WeatherDAO dao;
	
	@Test
	public void list() throws Exception{
		WeatherVO vo = new WeatherVO();
		vo.setDate("���ó�¥11��.04��(������)");
		vo.setRegion("���");
		dao.list(vo);
	}
}
