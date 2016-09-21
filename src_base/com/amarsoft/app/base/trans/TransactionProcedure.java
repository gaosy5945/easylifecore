package com.amarsoft.app.base.trans;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;

/**
 * @author yegang 通用交易接口定义文件
 */

public abstract class TransactionProcedure {
	
	protected BusinessObjectManager bomanager=null;
	protected BusinessObject transaction=null;
	protected String transactionCode=null;
	protected String scriptID=null;
	protected BusinessObject documentObject=null;
	protected BusinessObject relativeObject=null;
	
	public abstract int run() throws Exception;
	
	public BusinessObjectManager getBOManager() {
		return bomanager;
	}
	public void setBOManager(BusinessObjectManager bomanager) {
		this.bomanager = bomanager;
	}
	public BusinessObject getDocumentObject() {
		return documentObject;
	}
	public void setdocumentObject(BusinessObject documentObject) {
		this.documentObject = documentObject;
	}
	public BusinessObject getRelativeObject() {
		return relativeObject;
	}
	public void setRelativeObject(BusinessObject relativeObject) {
		this.relativeObject = relativeObject;
	}
	public BusinessObject getTransaction() {
		return transaction;
	}
	public void setTransaction(BusinessObject transaction) throws JBOException {
		this.transaction = transaction;
		String relativeObjectType = transaction.getString("RelativeObjectType");// 交易对应的借据对象
		String relativeObjectNo = transaction.getString("RelativeObjectNo");
		relativeObject = transaction.getBusinessObjectByKey(relativeObjectType, relativeObjectNo);
		String documentType = transaction.getString("DocumentType");// 交易对应的单据对象
		String documentNo = transaction.getString("DocumentNo");
		documentObject = transaction.getBusinessObjectByKey(documentType, documentNo);
	}

	public static TransactionProcedure create(BusinessObject transaction,BusinessObject tpconfig,BusinessObjectManager bomanager) throws Exception{
		String transactionCode=transaction.getString("TransCode");
		TransactionProcedure tp = TransactionProcedure.create(transactionCode, tpconfig, bomanager);
		tp.setTransaction(transaction);
		return tp;
	}
	
	public static TransactionProcedure create(String transactionCode,BusinessObject tpconfig,BusinessObjectManager bomanager) throws Exception{
		String classname = tpconfig.getString("class");
		TransactionProcedure tp=null;
		Class<?> c = Class.forName(classname);
		tp = ((TransactionProcedure) c.newInstance());
		
		tp.bomanager=bomanager;
		tp.transactionCode=transactionCode;
		tp.scriptID=tpconfig.getString("id");;
		return tp;
	}
}
