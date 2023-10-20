package com.model2.mvc.service.purchase.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.purchase.PurchaseDao;


@Repository("purchaseDaoImpl")
public class PurchaseDaoImpl implements PurchaseDao{
	
	//Field
	@Autowired
	@Qualifier("sqlSessionTemplate") 
	private SqlSession sqlSession; // 데이터베이스와의 연결, 쿼리 실행 등을 처리
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	//Constructor
	public PurchaseDaoImpl() {
		System.out.println("Purchase dao 임플 입니다 확인용 "+this.getClass());
	}
	
	//Method
	@Override
	public int getTotalCount(Search search) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("PurchaseMapper.getTotalCount", search);
	}

	@Override
	public Purchase findPurchase(int tranNo) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("tranNo 찍히는지 확인하기 ::::"+tranNo);
		return sqlSession.selectOne("PurchaseMapper.getPurchase", tranNo);
	}

	@Override
	public void insertPurchase(Purchase purchase) throws Exception {
		// TODO Auto-generated method stub
		sqlSession.insert("PurchaseMapper.addPurchase", purchase);
	}

//	@Override
//	public int updateTranCode(int tranNo) throws Exception {
//		// TODO Auto-generated method stub
//		return sqlSession.update("PurchaseMapper.updateTranCode", tranNo);
//	}
	
	@Override
	public void updateTranCode(Purchase purchase, String tranCode) throws Exception {
		
		Map map = new HashMap();
		
		map.put("purchase", purchase);
		map.put("tranCode", tranCode);
		
		sqlSession.update("PurchaseMapper.updateTranCode", map);

	}

	@Override
	public List<Purchase> getPurchaseList(Search search, String buyerId) throws Exception {
		
		System.out.println("daoImpl getpurchaselist 들어옴 ============!!!!!!!");
		Map map = new HashMap();
		
		System.out.println("search 정보 들어오는지 Dao Imple 확인하기 "+search);
		System.out.println("buyerId 정보 들어오는지 Dao Imple 확인하기 "+buyerId);
		map.put("search", search);
		map.put("buyerId", buyerId);
		
		System.out.println("map에 저장됬는지 확인해보기 ++++"+map);
		
		return sqlSession.selectList("PurchaseMapper.getPurchaseList", map);
	}

	@Override
	public List<Purchase> getSaleList(Search search) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("PurchaseMapper.getPurchaseList", search);
	}

	@Override
	public void updatePurchase(Purchase purchase) throws Exception {
		// TODO Auto-generated method stub
		sqlSession.update("PurchaseMapper.updatePurchase", purchase);
	}

}
