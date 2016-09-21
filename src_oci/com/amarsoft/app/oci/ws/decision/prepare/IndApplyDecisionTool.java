package com.amarsoft.app.oci.ws.decision.prepare;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

public class IndApplyDecisionTool {
	
	
	
	public String getAIMAMT(String aimValue,String educationValue,String businesstype,String productId){				
		   if("009".equals(businesstype)){ 
			   if("061@062@063".indexOf(productId)>-1){ //���˳������ڷ������
				   return aimValue;
			   }
			   else{ //��ѧ����
				   return educationValue; 
			   }
		   }
		   else if("005".equals(businesstype)){ //�������Ѵ���
			   return aimValue;
		   }
		   else {
			   return "0";
		   }		   
	}
	
	//��ݺ�
	public String addOne(String value){
		return value = value.substring(0, 14) + "01";
	}
	//�з�
	public String getSeparate(String value){
		return value.substring(0, 1);
	}
//	public String getCHAMPLABEL(String CHAMPION_LABEL){
//		if(CHAMPION_LABEL == null || CHAMPION_LABEL.equals("")) 
//			return "-1";
//		else return CHAMPION_LABEL;
//	}
	//�����������ʸ�������
	public String getFLTINTRATE(String RATEFLOAT){
		if(RATEFLOAT == null || RATEFLOAT.equals(""))
			return "0.0";
		else return RATEFLOAT;
	}
	//��������־
	public String getEXCEPTIONLOAN(String NONSTDINDICATOR){
		if(NONSTDINDICATOR.equals(Classification.EXCEPTION_APPROVE_BUSINESS)) 
			return "1";
		else return "0";
	}
	//�Ƿ񱾵ػ���
	public String getNativeflag(String flag){
		if(flag.equals(Classification.LOCAL_RESIDENT)) 
			return "1";
		else return "2";
	}	
	//������ʶ
	public String getFLAG(String count){
		if("0.0".equals(count)||"0".equals(count)) 
			return "0";
		else return "1";
	}	
	
	//����»����  ��������ޣ�ִ������,���ʽ,��������
	public String getMONTHAMT(String businesssum, String businessterm,String businessrate,String rpttermId,String segterm) throws JBOException{
		if(businesssum.equals("")) return "0";
		Double sum =  Double.parseDouble(businesssum);
		Double term;
		if("RPT-07".equals(rpttermId)||"RPT-08".equals(rpttermId)){ //��ʽΪ�����
			if(!"".equals(segterm))term = Double.parseDouble(segterm);	
			else term = 0.0;
		}
		else{ //���ʽΪ�ȶ��ȱ� 
			term = Double.parseDouble(businessterm);
		}
		Double rate = Double.parseDouble(businessrate)/100.0/12;
		//�ȶ��    ������� / ����������+������ �� �ѹ黹�����ۼƶ��ÿ������ )
        if("RPT-02".equals(rpttermId)||"RPT-08".equals(rpttermId)){ 
        	Double d = sum/term+sum*rate;
        	return d.toString();
        }
        //�ȶϢ     �۴����������ʡ���1�������ʣ��޻��������ݡ£ۣ�1�������ʣ��޻���������1��
        else { 
        	if(Math.abs(rate) < 0.0000001){
    			return "0";
    		}
    		else {
    			Double d = sum*rate*Math.pow((1+rate), term)/(Math.pow((1+rate), term)-1);
    			return d.toString();
    		}
        }
	}
	
	public String getRptChangeValue(String rpttermID){
		if("RPT-01".equals(rpttermID)){
			return "10";
		}
		if("RPT-02".equals(rpttermID)){
			return "20";
		}

		return "10";
		
	}
	public String getHouseAge(String finishDate) throws Exception{
		int date = DateHelper.getYears(finishDate,DateHelper.getBusinessDate());
		if(date < 0) date = 0;
		return ""+date;
	}
	
	public String getTwoTOT(String value1,String value2){		
		double result = Double.parseDouble(value1)+Double.parseDouble(value2);
		return ""+result;
	}
	
	public String getThreeTOT(String value1,String value2,String value3){
		double result = Double.parseDouble(value1)+Double.parseDouble(value2)+Double.parseDouble(value3);
		return ""+result;
	}
	
	public String getTerm(String termunit,String businessterm,String termday){
		String term = null;
		if(termunit.equals("D")){  //����
			int uv = Integer.parseInt(businessterm);
			int a = uv/30;
			int b = uv%30;
			NumberFormat nf = new DecimalFormat("00");
			term = "00"+nf.format(a)+nf.format(b);
		}
		else if(termunit.equals("M")){ //����
			NumberFormat nf = new DecimalFormat("00");
		    termday = nf.format(Integer.parseInt(termday));
		    int uv = Integer.parseInt(businessterm);
			int a = uv/12;
			int b = uv%12;							
			term = nf.format(a)+nf.format(b)+termday;
		}
		else if(termunit.equals("Y")){ //����
			int uv = Integer.parseInt(businessterm);
			NumberFormat nf = new DecimalFormat("00");
			term = nf.format(uv)+"00"+"00";
		}
		return term;
	}
	
	public String getMarriageCondition(String marriageCondition,String haveChildren) throws Exception{
		String status ="";
		String marriage = changeCode(marriageCondition,"MaritalStatus","ATTRIBUTE2");			
		if("1".equals(marriage)&&"1".equals(haveChildren)){ //�ѻ�����Ů
			status = "1";
		}
		else if("1".equals(marriage)&&"2".equals(haveChildren)){ //�ѻ�����Ů
			status = "2";
		}
		else{
			status = marriage;
		}
		return status;
	}
	
	//����״̬
	public String getTRMCLASS(String normal ,String overdue){	
		if(!"".equals(normal)&&!"".equals(overdue)){
			double n = Double.parseDouble(normal);
			double o = Double.parseDouble(overdue);
			if(o!=0){
				return "1";
			}
			else if(n!=0){
				return "0";
			}
			else return "2";
		}
		else{
			return "";
		}
	}
	
	public int getAge(String beginDate) throws ParseException, Exception{
		return DateHelper.getYears(beginDate, DateHelper.getBusinessDate());
	}
	
	public String getSixCount(String value1,String value2,String value3,String value4,String value5,String value6){
		double value = Double.parseDouble(value1)+Double.parseDouble(value2)+Double.parseDouble(value3)+Double.parseDouble(value4)+Double.parseDouble(value5)+Double.parseDouble(value6);
		return ""+value;
	}
	
	//ת��
	public static String changeCode(String code ,String codeType,String toCode) throws Exception {
		Item[] items = CodeCache.getItems(codeType);
		for (Item iTemp : items) {
			if (iTemp.getItemNo() != null && iTemp.getItemNo().startsWith(code)) {
				if(toCode.equals("BANKNO")){
					code = iTemp.getBankNo();
				    break;
				}
				else if(toCode.equals("ATTRIBUTE2")){
					code = iTemp.getAttribute2();
					break;
				}
				else if(toCode.equals("ATTRIBUTE3")){ 
					code = iTemp.getAttribute3();
					break;
				}
				else if(toCode.equals("SORTNO")){ 
					code = iTemp.getSortNo();
					break;
				}
				else if(toCode.equals("ATTRIBUTE7")){
					code = iTemp.getAttribute7();
					break;
				}
				else{
					break;
				}
			}
		}
		return code;
	}
	
	public String getCLInfo(String totalAmt,String consumerAmt){
		if(consumerAmt!=null&&!consumerAmt.equals("")){
			return consumerAmt;
		}
		else if(totalAmt!=null&&!totalAmt.equals("")){
			return totalAmt;
		}
		else {
			return "0.0";
		}
	}
	
	
	public String getDebt(String utableValue){
		if(utableValue.equals("")){
			return "";
		}
		else{
			Double debt = Double.parseDouble(utableValue);
			debt = debt/100.0;
			if(debt <= 0.5 ){
				return "1";
			}
			else if(debt <=0.6){
				return "2";
			}
			else if(debt <=0.7){
				return "3";				
			}
			else{
				return "4";
			}
		}
	}
	
	public String getHouseType(String countpartyName,String countpartyRegion,String businesstype){
		if("001".equals(businesstype)){ //һ�ַ�
			return "1";
		}
		else if("002".equals(businesstype)){ //���ַ�
			return "2";
		}
		else if("003".equals(businesstype)){
			if( (countpartyName == null||"".equals(countpartyName))&&(countpartyRegion == null||"".equals(countpartyRegion))){
				return "1";
			}
			else{
				return "2";
			}
		}
		else {
			return "";
		}
	}
	
	public String getLoanStatus(String loanStatus,String creditStatus){
		if(creditStatus.equals("1")){ //����ҵ����			
			return loanStatus;
		}
		else{
			return "-1";
		}
	}
	
	public String getRefuseFlag(String approveResult,String refuseFlag){
		if("1".equals(refuseFlag)){ // �������Զ��ܾ�
			return "1";
		}
		else if("0".equals(refuseFlag)) { //����δ���ܾ�
			if(!refuseFlag.equals(""))
				return "".equals(approveResult)?"0":approveResult;
			else 
				return "0";
		} 
		else{ //��һ�ε���
			return "0";
		}
	}
}
