package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 一个集团所属的集团成员中，只能有一个为母公司,本方法检查集团中是否已经存在母公司,改编自Class_method的methodName=CheckMultiParent
 * @author 核算团队
 * @date 2015-12-10
 */
public class CheckMultiParent{

    private static final String SUCCESS = "Success";
    private static final String FAILED = "Failed";
    
    private String relativeID;
    
    public String getRelativeID() {
		return relativeID;
	}

	public void setRelativeID(String relativeID) {
		this.relativeID = relativeID;
	}

	/**
     * 通过传入的集团编号，从GROUP_RELATIVE表中进行查找，以此来确定是否有集团成员为母公司。
     * @param RelativeID 集团编号
     * @return  如果存在一个集团成员为母公司，则返回"Failed",否则返回"Success"
     */
    public Object checkMultiParent(JBOTransaction tx) throws Exception {
        Transaction Sqlca = Transaction.createTransaction(tx);
        int iCount = 0;
        if (relativeID == null) relativeID = "";//集团编号
        //从GROUP_RELATIVE表中进行查找，以此确定是否已经存在母公司
        String sqlStr =  " select Count(*)" +
                " from GROUP_RELATIVE" +
                " Where RelativeID = :sRelativeID and RelationShip = '1010'";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sqlStr).setParameter("sRelativeID", relativeID));
        if (rs.next()) {
            iCount = rs.getInt(1);
        }
        rs.getStatement().close();
        String addParent = iCount > 0 ? FAILED : SUCCESS;
        return addParent;
    }
}
