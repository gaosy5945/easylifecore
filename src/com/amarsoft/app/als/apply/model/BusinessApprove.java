package com.amarsoft.app.als.apply.model;

import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ҵ����������
 * @author lyin
 *
 */
public class BusinessApprove {
	
	private BizObject boApprove;
	private BizObjectManager bm;
	private JBOTransaction tran;
	private String objectNo="";
	
	public BusinessApprove(JBOTransaction tx,String approveNo) throws JBOException{
		bm=JBOFactory.getBizObjectManager(CreditConst.BAP_JBOCLASS);
		objectNo=approveNo;
		this.tran=tx;
		if(tran!=null) tx.join(bm);
		if(objectNo!=null)boApprove=bm.createQuery("serialNo=:serialNo").setParameter("serialNo", objectNo).getSingleResult(tx!=null);
		
	}
	

	/**
	 * ������������
	 * @throws JBOException 
	 */
	public void saveObject() throws JBOException{
		if(bm!=null){
			if(tran==null) throw new JBOException("δ�������񣬲��ܽ��б���!"+this.getClass().getName());
			bm.saveObject(boApprove);
		}
	}
	
	
	/**
	 * ��ö���
	 * @return
	 */
	public BizObject getBizObject(){
		return this.boApprove;
	}
	
	/**
	 * ���ͻ��Ƿ����δ�ս����������
	 * @return 
	 * @throws Exception 
	 */
	public String checkBusinessApprove(String customerID,String userID) throws Exception{
		String result = "false";
		//�������������δ�鵵������Ϊ��δ�ս�
		if(bm!=null){
			int iResult = bm.createQuery("CustomerID=:CustomerID and PigeonholeDate is null and OperateUserID=:OperateUserID")
					.setParameter("CustomerID", customerID).setParameter("OperateUserID",userID).getTotalCount();
		    if(iResult > 0) result = "true";

		}
		return result;
	}
}
