package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.awe.util.Transaction;

/**
 * �����Ѽ��ػ��棬������������SQL����
 * ҵ�����ϼ��
 * @author zhangwl
 * @since 2014/03/25
 */

public class ProductCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		@SuppressWarnings("unchecked")
		List<BusinessObject> businessApplyList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ
		if(businessApplyList == null || businessApplyList.isEmpty()){
			putMsg("���������Ϣδ�ҵ������飡");
		}
		else{
			for(BusinessObject businessApply:businessApplyList){
				List<String> m = ProductAnalysisFunctions.checkProduct(businessApply);
				for(String s:m){
					putMsg(s);
				}
			}
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
