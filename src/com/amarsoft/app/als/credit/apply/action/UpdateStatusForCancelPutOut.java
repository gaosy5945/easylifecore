package com.amarsoft.app.als.credit.apply.action;


import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 终止放款时类更新BA、BC、BP的状态
 * @author 张万亮
 *
 */
public class UpdateStatusForCancelPutOut{
	
	private String applySerialNo;
	

	public String getApplySerialNo() {
		return applySerialNo;
	}


	public void setApplySerialNo(String applySerialNo) {
		this.applySerialNo = applySerialNo;
	}


	public String update(JBOTransaction tx) throws Exception{

		JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY",tx)
		.createQuery("update O set ApproveStatus = '00' where SerialNo = :SerialNo")
		.setParameter("SerialNo",applySerialNo)
		.executeUpdate();
		
		JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT",tx)
		.createQuery("update O set  ContractStatus = '05' where ApplySerialNo = :SerialNo")
		.setParameter("SerialNo",applySerialNo)
		.executeUpdate();
		
		JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PUTOUT",tx)
		.createQuery("update O set  PutOutStatus = '04' where ApplySerialNo = :SerialNo")
		.setParameter("SerialNo",applySerialNo)
		.executeUpdate();
		
		BizObjectQuery query = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE",tx)
				.createQuery(" ApplySerialNo = :ApplySerialNo and ObjectType = 'jbo.app.BUSINESS_APPLY' and RelativeType = '07'")
				.setParameter("ApplySerialNo", applySerialNo);
				 
		@SuppressWarnings("unchecked")
		List<BizObject> bos = query.getResultList(false);

		if(bos!=null)
		for(int i=0;i<bos.size();i++){
			BizObject bo = (BizObject) bos.get(i);
			String ObjectNo=bo.getAttribute("ObjectNo").getString();
			
			JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY",tx)
			.createQuery("update O set ApproveStatus = '00' where SerialNo = :SerialNo")
			.setParameter("SerialNo", ObjectNo)
			.executeUpdate();
			
			JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT",tx)
			.createQuery("update O set ContractStatus = '05' where ApplySerialNo = :SerialNo")
			.setParameter("SerialNo", ObjectNo)
			.executeUpdate();
 
			JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PUTOUT",tx)
			.createQuery("update O set PutOutStatus = '04' where ApplySerialNo = :SerialNo")
			.setParameter("SerialNo", ObjectNo)
			.executeUpdate();
		}
	 
		
		query = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE",tx)
				.createQuery(" ObjectNo = :ApplySerialNo and ObjectType = 'jbo.app.BUSINESS_APPLY' and RelativeType = '07'")
				.setParameter("ApplySerialNo", applySerialNo);
		 
		@SuppressWarnings("unchecked")
		List<BizObject> bos1 = query.getResultList(false);
 
		if(bos1!=null)
		for(int i=0;i<bos1.size();i++){
			BizObject bo = (BizObject) bos1.get(i);
			String ObjectNo=bo.getAttribute("ApplySerialNo").getString();
			
			JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY",tx)
			.createQuery("update O set ApproveStatus = '00' where SerialNo = :SerialNo")
			.setParameter("SerialNo", ObjectNo)
			.executeUpdate();
			
			JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT",tx)
			.createQuery("update O set ContractStatus = '05' where ApplySerialNo = :SerialNo")
			.setParameter("SerialNo", ObjectNo)
			.executeUpdate();
 
			JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PUTOUT",tx)
			.createQuery("update O set PutOutStatus = '04' where ApplySerialNo = :SerialNo")
			.setParameter("SerialNo", ObjectNo)
			.executeUpdate();
		
		}
	 
		return "true";
	}
}
	

