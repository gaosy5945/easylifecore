package com.amarsoft.app.als.prd.transaction.script.changestatus;

import java.util.List;

import com.amarsoft.app.als.awe.script.WebBusinessProcessor;
import com.amarsoft.app.als.prd.web.ProductSpecificManager;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class UpdateStatusForCancelProductApply extends WebBusinessProcessor {

	public String deleteTransaction(JBOTransaction tx) throws Exception{
		this.setTx(tx);
		String transactionGroup = this.getStringValue("TransactionGroup");
		String transactionSerialNo = this.getStringValue("TransactionSerialNo");
		BizObjectManager pt = JBOFactory.getBizObjectManager(transactionGroup);
		tx.join(pt);
		
		BizObjectManager ptr = JBOFactory.getBizObjectManager("jbo.prd.PRD_TRANSACTION_RELATIVE");
		tx.join(ptr);
		try{
			BizObjectQuery ptq = pt.createQuery("SerialNo=:SerialNo");
			ptq.setParameter("SerialNo", transactionSerialNo);
			BizObject ptbo = ptq.getSingleResult(false);
			String transCode = ptbo.getAttribute("TransCode").getString();
			String productID = ptbo.getAttribute("ObjectNo").getString(); 
			//取消的交易如果是新增则删掉PRD_PRODUCT_LIBRARY、PRD_PRODUCT_RELATIVE、PRD_SPECIFIC_LIBRARY对应数据，停用和修改不删
			if("0010".equals(transCode)){
				BizObjectManager ppl = JBOFactory.getBizObjectManager("jbo.prd.PRD_PRODUCT_LIBRARY");
				tx.join(ppl);
				BizObjectManager ppr = JBOFactory.getBizObjectManager("jbo.prd.PRD_PRODUCT_RELATIVE");
				tx.join(ppr);
				BizObjectManager pvl = JBOFactory.getBizObjectManager("jbo.prd.PRD_VIEW_LIBRARY");
				tx.join(pvl);
				
				BizObjectQuery pprq = ppr.createQuery("ProductID=:ProductID and ObjectType = 'jbo.prd.PRD_SPECIFIC_LIBRARY'");
				pprq.setParameter("ProductID", productID);
				List<BizObject> pplboList = pprq.getResultList(false);
				for(BizObject pplbo:pplboList){
					String pslSerialNo = pplbo.getAttribute("ObjectNo").getString();
					ProductSpecificManager psm = new ProductSpecificManager();
					psm.setInputParameter("SpecificSerialNo", pslSerialNo);
					psm.deleteSpecific(tx);
				}
				ppr.createQuery("delete from O where ProductID = :ProductID or ObjectNo = :ProductID").setParameter("ProductID", productID).executeUpdate();
				ppl.createQuery("delete from O where ProductID = :ProductID").setParameter("ProductID", productID).executeUpdate();
				pvl.createQuery("delete from O where ProductID = :ProductID").setParameter("ProductID", productID).executeUpdate();
			}
			ptr.createQuery("delete from O where TransactionSerialNo=:TransactionSerialNo").setParameter("TransactionSerialNo", transactionSerialNo).executeUpdate();
			pt.createQuery("delete from O where SerialNo=:SerialNo").setParameter("SerialNo", transactionSerialNo).executeUpdate();
			tx.commit();
			return "1";
		}catch(Exception ex)
		{
			tx.rollback();
			ex.printStackTrace();
			return ex.getMessage().toString();
		}
	}

}
