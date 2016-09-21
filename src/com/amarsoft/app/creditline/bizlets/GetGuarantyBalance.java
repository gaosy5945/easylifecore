/**
 * ȡ�õ�����ͬ�Ŀ��õ������
 * @author syang
 * @date 2009/10/20
 */
package com.amarsoft.app.creditline.bizlets;

import java.text.DecimalFormat;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.SqlObject;



public class GetGuarantyBalance {
	private String guarantyNo=null;
	
	public Object  getGuarantyBalance(JBOTransaction tx) throws JBOException{
	 
	 	/**
	 	 * ������ͬ��
	 	 */
	 	String sGuarantyNo = this.guarantyNo;
	 	if(sGuarantyNo == null) sGuarantyNo = "";
	 	
	 	/**
	 	 * �������
	 	 */
	 	String sSql = "";
	 	String sTmp = "";
	 	
	 	double dUsedLimit = 0.0;		//��ռ�ö��
	 	double dGuarantySum = 0.0;		//�ܵ������
	 	double dGuarantyBalance = 0.0; 	//�������
		SqlObject so = null;//��������
	 	
	 	//��ѯ�ñʵ�������������ҵ���ͬ������ȡ����Ч��ͬ���������ǵ��ܶ�
		sSql = "select sum(O.Balance*GetErate(O.businesscurrency,'01','')) as v.calResult from O  "
	 			+" where O.SerialNo in("
	 			+" select CR.SerialNo from jbo.app.Contract_Relative  CR "
	 			+" where CR.objecttype='GuarantyContract' "
	 			+" and CR.ObjectNo=:ObjectNo "
	 			+")"
	 			+" and (O.FinishDate is null or O.FinishDate = '' or O.FinishDate = ' ')"
	 			;
		BizObjectQuery query = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT",tx)
		.createQuery(sSql)
		.setParameter("ObjectNo", sGuarantyNo);
		
		
		@SuppressWarnings("unchecked")
		List<BizObject> bos = query.getResultList(false);
		if(bos==null || bos.size()<1){
			sTmp = "0";
		}else{
			sTmp = bos.get(0).getAttribute("calResult").toString();
		}
	 	
	 	dUsedLimit = Double.parseDouble(sTmp);
	 	
	 	//ȡ���������ܶ�
	 	sSql = "select GuarantyValue*GetErate(GuarantyCurrency,'01','')  as v.calResult from O where SerialNo=:SerialNo";
	 	
	 	BizObjectQuery query1 = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT",tx)
	 			.createQuery(sSql)
	 			.setParameter("SerialNo", sGuarantyNo);
	 	@SuppressWarnings("unchecked")
		List<BizObject> bos1 = query1.getResultList(false);
		if(bos1==null || bos1.size()<1){
			sTmp = "0";
		}else{
			sTmp = bos1.get(0).getAttribute("calResult").toString();
		}
 	 	dGuarantySum = Double.parseDouble(sTmp);
	 	
	 	//���㵣�����
	 	dGuarantyBalance = dGuarantySum - dUsedLimit;
	 	DecimalFormat df = new DecimalFormat("#.####");//�����С��������4λС��
	 	sTmp = df.format(dGuarantyBalance);
	 	return sTmp;
 }

	public String getGuarantyNo() {
		return guarantyNo;
	}

	public void setGuarantyNo(String guarantyNo) {
		this.guarantyNo = guarantyNo;
	}
}
