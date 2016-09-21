package com.amarsoft.app.bizmethod;

import java.util.HashMap;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
/**
 * @author �����Ŷӣ�12/09/2015
 * */
public class BusinessManage {
	private String paras;//������
	private String splitStr;//�ָ�������:Ĭ��ֵ@@
	private String paraSplit;//������ֵ�ķָ���Ĭ��ֵ@~
	//tableName@~acct_loan@@col@~sex      
	public String getParaSplit() {
		return paraSplit;
	}
	public void setParaSplit(String paraSplit) {
		this.paraSplit = paraSplit;
	}
	public String getParas() {
		return paras;
	}
	public void setParas(String paras) {
		this.paras = paras;
	}
	public String getSplitStr() {
		return splitStr;
	}
	public void setSplitStr(String splitStr) {
		this.splitStr = splitStr;
	}
	/*/ALS74A/src/com/amarsoft/app/aa/BusinessManage.java
	 *ҳ����spdb_web/WebContent/Common/EDOC/EDocDefineList.jsp
	 *�����Ӻ�ͬģ���Ƿ�ռ�ã���class_method�еķ����ı����
	 * SELECT * FROM class_method where classname='BusinessManage' and methodname='SelectEDocDefine';
	 * */
	public String selectDocDefine(JBOTransaction tx) throws JBOException{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.app.PUB_EDOC_PRINT");
		tx.join(bom);
		HashMap<String,String> map = ParseAttirbutesTool.parseParas(paras,splitStr,paraSplit);
		String sql = "select count(*) as v.num from O where EDOCNO=:docNo";
		BizObjectQuery boq = bom.createQuery(sql).setParameter("docNo", map.get("docNo"));
		BizObject bo = boq.getSingleResult(false);
		if(bo==null) throw new JBOException("û�л�ȡ���κ����ݣ���鿴�����Ƿ񴫵ݴ���");
		String count = bo.getAttribute("num").toString();
		return count;
	}
	
	public void updateGuarantyContractStatus(JBOTransaction tx) throws JBOException{
		HashMap<String, String> as = ParseAttirbutesTool.parseParas(paras);
		JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT",tx)
		.createQuery("update O set ContractStatus=:ContractStatus  where SerialNo =:SerialNo")
		.setParameter("SerialNo", as.get("SerialNo"))
		.setParameter("ContractStatus", as.get("ContractStatus")).executeUpdate()
		;
	}
	
	public String checkGuaranrtyContract(JBOTransaction tx) throws JBOException{
		HashMap<String, String> as = ParseAttirbutesTool.parseParas(paras);
		String count= JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT",tx)
		.createQuery("select count(SerialNo) as v.num from GUARANTY_CONTRACT where SerialNo =:SerialNo and GuarantorID =:CustomerID")
		.setParameter("SerialNo", as.get("SerialNo"))
		.setParameter("GuarantorID", as.get("CustomerID")).getSingleResult(false).getAttribute("num").toString()
		;
		return count;
	}
	
	public void insertRelative(JBOTransaction tx) throws Exception{
		HashMap<String, String> as = ParseAttirbutesTool.parseParas(paras);
		//tableName
		Transaction Sqlca = Transaction.createTransaction(tx);
		SqlObject sql = new SqlObject("insert into "+as.get("tableName")+"(SerialNo,ObjectType,ObjectNo) values('"
				+as.get("serialNo")+"','"+as.get("objectType")+"','"+as.get("objectNo")+"')");
		Sqlca.executeSQL(sql);
		/*JBOFactory.getBizObjectManager(as.get("jboName"),tx)
		.createQuery("insert into O(SerialNo,ObjectType,ObjectNo) values(:SerialNo,:ObjectType,:ObjectNo)")
		.setParameter("SerialNo", as.get("serialNo"))
		.setParameter("ObjectType", as.get("objectType"))
		.setParameter("ObjectNo", as.get("objectNo")).executeUpdate()
		;*/
 	}
}
