package com.example.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.example.domain.WeatherVO;

@Repository
public class WeatherDAOImpl implements WeatherDAO{
	@Inject
	SqlSession session;

	private static final String namespace="WeatherMapper";
	
	@Override
	public List<WeatherVO> list(WeatherVO vo) throws Exception {
		
		// TODO Auto-generated method stub
		return session.selectList(namespace+".list",vo);
	}

	@Override
	public void winsert(WeatherVO vo) throws Exception {
		// TODO Auto-generated method stub
		session.insert(namespace+".winsert",vo);
	}

}
