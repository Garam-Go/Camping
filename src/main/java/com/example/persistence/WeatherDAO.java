package com.example.persistence;

import java.util.List;

import com.example.domain.WeatherVO;

public interface WeatherDAO {
	public List<WeatherVO> list(WeatherVO vo)throws Exception;
	public void winsert(WeatherVO vo) throws Exception;
}
