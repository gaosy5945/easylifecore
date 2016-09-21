package com.amarsoft.app.als.assetTransfer.handler;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * ��������Ŀ����
 * @author fengcr
 * @2014-12-25
 */
public class ProjectCalInfoHandler extends CommonHandler {

	@Override
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		String serialNo = asPage.getParameter("SerialNo");
		List<BizObject> list = JBOFactory.getFactory().getManager("jbo.prj.PRJ_ASSET_INFO").createQuery("O.ObjectType = 'jbo.app.BUSINESS_DUEBILL' and O.PROJECTSERIALNO = :serialNo").setParameter("serialNo",serialNo).getResultList();
		Set<String> orgs = new HashSet<String>();//�漰������
		Set<String> loanType = new HashSet<String>();//�漰��Ʒ��
		Set<String> users = new HashSet<String>();//���������
		Set<String> classify = new HashSet<String>();//������������
		Set<String> classifyCustomer = new HashSet<String>();//���������
		double totalSum = 0.0;//�ʲ���ģ�ϼƣ��ۺ�����ң�
		double totalGuaranteePeriod = 0.0;
		double totalLeftPeriod = 0.0;
		double tempBalance = 0.0;//�ж�balance�Ƿ�Ϊ������ʱֵ
		double tempBusinessSum = 0.0;//�ж�businessSum�Ƿ�Ϊ����ͬ���
		double tempActualBusinessRate = 0.0;//�ж�actualBusinessRate�Ƿ�Ϊ�������
		double tempLongestLeftPeriod = -0.001;//�ж�leftPeriod�Ƿ�Ϊ���ʣ������,���ò����ܳ��ֵ�ֵ������ֵ
		double tempShortestLeftPeriod = -0.001;//�ж�leftPeriod�Ƿ�Ϊ��Сʣ������
		StringBuffer AreaBuffer = new StringBuffer();
		StringBuffer ProductBuffer = new StringBuffer();
		StringBuffer ClassifyBuffer = new StringBuffer();
		StringBuffer ClassifyCustomerBuffer = new StringBuffer();
		double totalValue = 0.0;
		//��orgs�ȱ��������������ȿ���ִ��һ���ѯ
		for(BizObject biz : list){
			String obejctNo = biz.getAttribute("OBJECTNO").toString();
			BizObject bdbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_DUEBILL").createQuery("O.SERIALNO = :serialNo").setParameter("serialNo",obejctNo).getSingleResult();
			orgs.add(bdbiz.getAttribute("INPUTORGID").getString());
			loanType.add(bdbiz.getAttribute("LOANTYPE").getString());
			classify.add(bdbiz.getAttribute("CLASSIFYRESULT").getString());
			BizObject ombiz = JBOFactory.getFactory().getManager("jbo.rds.OUTMESSAGE").createQuery("O.CINO = :CINO").setParameter("CINO",obejctNo).getSingleResult(true);
			if(ombiz == null){
				continue;
			}else{
				classifyCustomer.add(ombiz.getAttribute("SCORE").getString());
			}
		}
				
		Object[] orgName = orgs.toArray();
		int[] countArea = new int[orgName.length];
		Object[] loanTypeName = loanType.toArray();
		int[] countProduct = new int[loanTypeName.length];
		Object[] classifyName = classify.toArray();
		int[] countClassify = new int[classifyName.length];
		Object[] classifyCustomerName = classifyCustomer.toArray();
		int[] countClassifyCustomer = new int[classifyCustomerName.length];
		//ʵ�ʼ�������
		for(BizObject biz : list){
			String obejctNo = biz.getAttribute("OBJECTNO").toString();
			BizObject bdbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_DUEBILL").createQuery("O.SERIALNO = :serialNo").setParameter("serialNo",obejctNo).getSingleResult(true);
			orgs.add(bdbiz.getAttribute("INPUTORGID").getString());
			loanType.add(bdbiz.getAttribute("LOANTYPE").getString());
			classify.add(bdbiz.getAttribute("CLASSIFYRESULT").getString());
			users.add(bdbiz.getAttribute("CUSTOMERID").getString());
			//����������������
			String score = "";
			BizObject ombiz = JBOFactory.getFactory().getManager("jbo.rds.OUTMESSAGE").createQuery("O.CINO = :CINO").setParameter("CINO",obejctNo).getSingleResult(true);
			if(ombiz == null){
			}else{
				classifyCustomer.add(ombiz.getAttribute("SCORE").getString());
				score =ombiz.getAttribute("SCORE").getString();
			}
			double balance = bdbiz.getAttribute("BALANCE").getDouble();			
			if(balance >= tempBalance){
				tempBalance = balance;
			}else{}
			
			double businessSum = bdbiz.getAttribute("BUSINESSSUM").getDouble();
			if(businessSum >= tempBusinessSum){
				tempBusinessSum = businessSum;
			}else{}
			
			double actualBusinessRate = bdbiz.getAttribute("ACTUALBUSINESSRATE").getDouble();
			if(actualBusinessRate >= tempActualBusinessRate){
				tempActualBusinessRate = actualBusinessRate;
			}else{}
			
			String area = bdbiz.getAttribute("INPUTORGID").getString();
			if(area == null) area = "";
			//ͳ��ÿ��orgs��Ŀ
			for (int i=0; i < orgName.length; i++){
				if(area.equals(orgName[i])){
					countArea[i]++;
				}else{
					
				}
			}
			
			String product =bdbiz.getAttribute("LOANTYPE").getString();
			if(product == null) product = "";
			//ͳ��ÿ��product��Ŀ
			for (int i=0; i < loanTypeName.length; i++){
				if(product.equals(loanTypeName[i])){
					countProduct[i]++;
				}else{
					
				}
			}
			
			String sigleClassify =bdbiz.getAttribute("CLASSIFYRESULT").getString();
			if(sigleClassify == null) sigleClassify = "";
			//ͳ��ÿ��classify��Ŀ
			for (int i=0; i < classifyName.length; i++){
				if(sigleClassify.equals(classifyName[i])){
					countClassify[i]++;
				}else{
					
				}
			}
			
			
			if(score == null) score = "";
			//ͳ��ÿ��classifyCustomer��Ŀ
			for (int i=0; i < classifyCustomerName.length; i++){
				if(score.equals(classifyCustomerName[i])){
					countClassifyCustomer[i]++;
				}else{
					
				}
			}
			
			double totalPeriod = bdbiz.getAttribute("TOTALPERIOD").getDouble();
			double currentPeriod = bdbiz.getAttribute("CURRENTPERIOD").getDouble();
			double leftPeriod = totalPeriod - currentPeriod + 1;
			if(tempLongestLeftPeriod == -0.001 ){
				tempLongestLeftPeriod = leftPeriod;
			}else if(leftPeriod >= tempLongestLeftPeriod){
				tempLongestLeftPeriod = leftPeriod;
			}else{}
			
			if(tempShortestLeftPeriod == -0.001 ){
				tempShortestLeftPeriod = leftPeriod;
			}else if(leftPeriod <= tempShortestLeftPeriod){
				tempShortestLeftPeriod = leftPeriod;
			}else{}
			totalValue += businessSum*actualBusinessRate;
			totalSum += businessSum;
			totalGuaranteePeriod += totalPeriod;
			totalLeftPeriod += leftPeriod;
		}	

		
		double[] countAreaRate = new double[orgName.length];
		double[] countProductRate = new double[loanTypeName.length];
		double[] countClassifyRate = new double[classifyName.length];
		double[] countClassifyCustomerRate = new double[classifyCustomerName.length];
		java.text.NumberFormat nf = java.text.NumberFormat.getPercentInstance();
		nf.setMinimumFractionDigits(2);
		for(int i=0;i<orgName.length ;i++){
			countAreaRate[i] = (double)countArea[i]/(double)list.size();
			AreaBuffer = AreaBuffer.append(orgName[i]).append("   ").append(nf.format(countAreaRate[i])).append("\n");
		}
		for(int i=0;i<loanTypeName.length ;i++){
			countProductRate[i] = (double)countProduct[i]/(double)list.size();
			ProductBuffer = ProductBuffer.append(loanTypeName[i]).append("   ").append(nf.format(countProductRate[i])).append("\n");
		}
		for(int i=0;i<classifyName.length ;i++){
			countClassifyRate[i] = (double)countClassify[i]/(double)list.size();
			ClassifyBuffer = ClassifyBuffer.append(classifyName[i]).append("   ").append(nf.format(countClassifyRate[i])).append("\n");
		}
		for(int i=0;i<classifyCustomerName.length ;i++){
			countClassifyCustomerRate[i] = (double)countClassifyCustomer[i]/(double)list.size();
			ClassifyCustomerBuffer = ClassifyCustomerBuffer.append(classifyCustomerName[i]).append("   ").append(nf.format(countClassifyCustomerRate[i])).append("\n");
		}
		
		double averageRate = totalValue/totalSum;
		double averageGuaranteePeriod = totalGuaranteePeriod/list.size();
		double averageLeftPeriod = totalLeftPeriod/list.size();
		
		bo.setAttributeValue("LoanCount", list.size());
		bo.setAttributeValue("OrgCount", orgs.size());
		bo.setAttributeValue("UserCount", users.size());
		bo.setAttributeValue("TotalSum", totalSum);
		bo.setAttributeValue("HighestLeftAmount", tempBalance);
		bo.setAttributeValue("HighestGuaranteeAmount", tempBusinessSum);
		bo.setAttributeValue("HighestRate", tempActualBusinessRate);
		bo.setAttributeValue("AverageRate", averageRate);
		bo.setAttributeValue("Area", AreaBuffer);
		bo.setAttributeValue("Product", ProductBuffer);
		bo.setAttributeValue("Risk", ClassifyBuffer);
		bo.setAttributeValue("Evaluate", ClassifyCustomerBuffer);
		bo.setAttributeValue("AverageGaranteePeriod", averageGuaranteePeriod);
		bo.setAttributeValue("AverageLeftPeriod", averageLeftPeriod);
		bo.setAttributeValue("LongestLeftPeriod", tempLongestLeftPeriod);
		bo.setAttributeValue("ShortestLeftPeriod", tempShortestLeftPeriod);
	}
	
	
	
}
