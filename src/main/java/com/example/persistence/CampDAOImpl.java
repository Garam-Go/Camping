package com.example.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.example.domain.CampVO;
import com.example.domain.Criteria;

@Repository
public class CampDAOImpl implements CampDAO{
	
	@Inject
	SqlSession session;
	
	private static final String namespace="CampMapper";
	
	@Override
	public List<CampVO> list(Criteria cri) throws Exception {
		// TODO Auto-generated method stub
		return session.selectList(namespace+".list",cri);
	}
	@Override
	public void insert(CampVO vo) throws Exception {
		// TODO Auto-generated method stub
		session.insert(namespace +".insert",vo);		
	}

	@Override
	public void delete(int id) throws Exception {
		session.delete(namespace + ".delete", id);
	}

	@Override
	public void update(CampVO vo) throws Exception {
		System.out.println(vo.toString());
		session.update(namespace + ".update", vo);
		
	}
	@Override
	public int total() throws Exception {
		// TODO Auto-generated method stub
		return session.selectOne(namespace+".total");
	}

}
