package com.example.persistence;

import java.util.List;

import com.example.domain.CampVO;
import com.example.domain.Criteria;

public interface CampDAO {
	public List<CampVO> list(Criteria cri)throws Exception;
	public int total() throws Exception;
	public void insert(CampVO vo) throws Exception;
	public void delete(int id) throws Exception;
	public void update(CampVO vo) throws Exception;
}
