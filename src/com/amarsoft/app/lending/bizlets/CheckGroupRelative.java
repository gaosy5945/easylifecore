package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 检查所选择的集团成员是否已经与集团关联。
 * @author 核算团队
 * @date 2015-12-10
 */
public class CheckGroupRelative{

    private static final String SUCCESS = "Success";
    private static final String FAILED = "Failed";
    
    private String customerID;//集团客户编号
    private String relativeID;//集团编号
   
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
     * 通过传入的集团客户编号和集团编号，从GROUP_RELATIVE表中进行查找，以此来确定
     * 选择的集团成员是否已经与集团关联。
     * @param CustomerID 集团客户编号
     * @param RelativeID 集团编号
     * @return isRelated 未关联返回"Success"，已经关联返回"Failed"
     */
    public Object checkGroupRelative(JBOTransaction tx) throws Exception {
    	Transaction Sqlca = Transaction.createTransaction(tx);
        int count = 0;
        if (relativeID == null) relativeID = "";
        if (customerID == null) customerID = "";
        //从GROUP_RELATIVE表中进行查找，以此确定集团成员与集团是否已经关联
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
