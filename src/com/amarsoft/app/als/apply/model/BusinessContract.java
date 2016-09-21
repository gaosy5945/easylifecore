package com.amarsoft.app.als.apply.model;

import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ҵ���ͬ����
 * @author lyin
 *
 */
public class BusinessContract {
	
	private BizObject boContract;
	private BizObjectManager bm;
	private JBOTransaction tran;
	private String objectNo="";
	public BusinessContract(JBOTransaction tx,String contractNo) throws JBOException{
		bm=JBOFactory.getBizObjectManager(CreditConst.BC_JBOCLASS);
		objectNo=contractNo;
		this.tran=tx;
		if(tran!=null) tx.join(bm);
		if(objectNo!=null) boContract=bm.createQuery("serialNo=:serialNo").setParameter("serialNo", objectNo).getSingleResult(tx!=null);
		
	}
	

	/**
	 * ����ҵ���ͬ����
	 * @throws JBOException 
	 */
	public void saveObject() throws JBOException{
		if(bm!=null){
			if(tran==null) throw new JBOException("δ�������񣬲��ܽ��б���!"+this.getClass().getName());
			bm.saveObject(boContract);
		}
	}
	
	
	/**
	 * ��ö���
	 * @return
	 */
	public BizObject getBizObject(){
		return this.boContract;
	}
	
	/**
	 * ���ͻ��Ƿ����δ�ս��ҵ���ͬ
	 * @return 
	 * @throws Exception 
	 */
	public String checkBusinessContract(String customerID,String userID) throws Exception{
		String result = "false";
		//�����ҵ���ͬFinishDateΪ�գ�����Ϊ��δ�ս�
		if(bm!=null){
			int iResult = bm.createQuery("CustomerID=:CustomerID and FinishDate is null and ManageUserID=:ManageUserID")
					.setParameter("CustomerID", customerID).setParameter("ManageUserID",userID).getTotalCount();
		    if(iResult > 0) result = "true";

		}
		return result;
	}
}
