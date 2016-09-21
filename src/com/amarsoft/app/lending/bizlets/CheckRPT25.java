package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CheckRPT25 extends Bizlet{

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		String flag = "true@У��ͨ����";
		double businessSum = Double.parseDouble((String)this.getAttribute("BusinessSum"));
		String putOutDate = (String)this.getAttribute("PutOutDate");
		String maturity = (String)this.getAttribute("Maturity");
		String objectNo = (String)this.getAttribute("ObjectNo");
		String objectType = (String)this.getAttribute("ObjectType");
		BusinessObject businessObject= BusinessObject.createBusinessObject(objectType);
		String sql = " select * from ACCT_RPT_SEGMENT where RPTTermID like 'RPT25-02' and ObjectNo = '" + objectNo + "' and ObjectType='" 
				+ businessObject.getBizClassName() + "' and Status='0'";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql));
		double tempSum = 0.0d;
		while(rs.next()) {
			tempSum += rs.getDouble("SegRPTAmount");
			if(rs.getString("SegToDate") != null && !rs.getString("SegToDate").equals("")) {
				if(rs.getString("SegToDate").compareTo(putOutDate) <= 0)
					flag = "false@����ƻ�¼��Ľ�������С�ڴ���ſ����ڣ�";
				if(rs.getString("SegToDate").compareTo(maturity) > 0)
					flag = "false@����ƻ�¼��Ľ������ڴ��ڴ�������ڣ�";
			}
		}
		rs.close();
		if(tempSum < businessSum) {
			flag = "false@����ƻ�¼��Ļ������ܺ�С�ڴ��������";
		}
		return flag;
	}

}
