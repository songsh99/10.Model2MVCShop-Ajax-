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
	private SqlSession sqlSession; // �����ͺ��̽����� ����, ���� ���� ���� ó��
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	//Constructor
	public PurchaseDaoImpl() {
		System.out.println("Purchase dao ���� �Դϴ� Ȯ�ο� "+this.getClass());
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
		System.out.println("tranNo �������� Ȯ���ϱ� ::::"+tranNo);
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
		
		System.out.println("daoImpl getpurchaselist ���� ============!!!!!!!");
		Map map = new HashMap();
		
		System.out.println("search ���� �������� Dao Imple Ȯ���ϱ� "+search);
		System.out.println("buyerId ���� �������� Dao Imple Ȯ���ϱ� "+buyerId);
		map.put("search", search);
		map.put("buyerId", buyerId);
		
		System.out.println("map�� �������� Ȯ���غ��� ++++"+map);
		
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
