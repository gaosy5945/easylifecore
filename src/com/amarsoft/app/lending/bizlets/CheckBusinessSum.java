package com.amarsoft.app.lending.bizlets;

import java.util.List;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.dict.als.cache.CodeCache;

/**
 * �жϷſ����Ƿ񳬹���ͬ���
 * @author ������
 */
public class CheckBusinessSum extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		//�˺����͡�����
		
		String contractArtificialNo = (String)this.getAttribute("ContractArtificialNo");
		String serialNo = (String)this.getAttribute("SerialNo");
		double businessSum = Double.parseDouble((String)this.getAttribute("BusinessSum"));
		double bpBusinessSum = 0.0;
		double sumBpBusinessSum = 0.0;
		double bcBpBusinessSum = 0.0;
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select BusinessSum from BUSINESS_PUTOUT where "
				+ "ContractArtificialNo=:ContractArtificialNo and SerialNo<>:SerialNo and PutOutStatus in('01','02','03','05')")
				.setParameter("ContractArtificialNo", contractArtificialNo).setParameter("SerialNo", serialNo));
		while(rs.next()){
			bpBusinessSum = Double.parseDouble(rs.getString("BusinessSum"));
			sumBpBusinessSum += bpBusinessSum;
		}
		ASResultSet rsbc = Sqlca.getASResultSet(new SqlObject("select BusinessSum from BUSINESS_CONTRACT where "
				+ "ContractArtificialNo=:ContractArtificialNo").setParameter("ContractArtificialNo", contractArtificialNo));
		if(rsbc.next()){
			bcBpBusinessSum = Double.parseDouble(rsbc.getString("BusinessSum"));
		}
		double nBusinessSum = bcBpBusinessSum - sumBpBusinessSum ;
		rs.close();
		rsbc.close();
		if(businessSum>nBusinessSum){
			return "false@�ſ���ܳ�����ͬ���ý�"+nBusinessSum+"Ԫ��";
		}else{
			return "true@";
		}
	}
}
