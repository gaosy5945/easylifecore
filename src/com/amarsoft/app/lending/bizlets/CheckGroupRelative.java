package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �����ѡ��ļ��ų�Ա�Ƿ��Ѿ��뼯�Ź�����
 * @author �����Ŷ�
 * @date 2015-12-10
 */
public class CheckGroupRelative{

    private static final String SUCCESS = "Success";
    private static final String FAILED = "Failed";
    
    private String customerID;//���ſͻ����
    private String relativeID;//���ű��
   
    public String getCustomerID() {
    	return customerID;
	}
	
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	
	public String getRelativeID() {
		return relativeID;
	}
	
	public void setRelativeID(String relativeID) {
		this.relativeID = relativeID;
	}

	/**
     * ͨ������ļ��ſͻ���źͼ��ű�ţ���GROUP_RELATIVE���н��в��ң��Դ���ȷ��
     * ѡ��ļ��ų�Ա�Ƿ��Ѿ��뼯�Ź�����
     * @param CustomerID ���ſͻ����
     * @param RelativeID ���ű��
     * @return isRelated δ��������"Success"���Ѿ���������"Failed"
     */
    public Object checkGroupRelative(JBOTransaction tx) throws Exception {
    	Transaction Sqlca = Transaction.createTransaction(tx);
        int count = 0;
        if (relativeID == null) relativeID = "";
        if (customerID == null) customerID = "";
        //��GROUP_RELATIVE���н��в��ң��Դ�ȷ�����ų�Ա�뼯���Ƿ��Ѿ�����
        String sSql =  " select Count(*)" +
                " from GROUP_RELATIVE" +
                " Where RelativeID = :sRelativeID" +
                " and CustomerID = :sCustomerID";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID", customerID).setParameter("sRelativeID", relativeID));
        
        if (rs.next()) {
            count = rs.getInt(1);
        }
        rs.getStatement().close();
		String isRelated = count > 0 ? FAILED : SUCCESS;
        
        return isRelated;
    }
}
