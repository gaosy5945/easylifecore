package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * һ�����������ļ��ų�Ա�У�ֻ����һ��Ϊĸ��˾,��������鼯�����Ƿ��Ѿ�����ĸ��˾,�ı���Class_method��methodName=CheckMultiParent
 * @author �����Ŷ�
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
     * ͨ������ļ��ű�ţ���GROUP_RELATIVE���н��в��ң��Դ���ȷ���Ƿ��м��ų�ԱΪĸ��˾��
     * @param RelativeID ���ű��
     * @return  �������һ�����ų�ԱΪĸ��˾���򷵻�"Failed",���򷵻�"Success"
     */
    public Object checkMultiParent(JBOTransaction tx) throws Exception {
        Transaction Sqlca = Transaction.createTransaction(tx);
        int iCount = 0;
        if (relativeID == null) relativeID = "";//���ű��
        //��GROUP_RELATIVE���н��в��ң��Դ�ȷ���Ƿ��Ѿ�����ĸ��˾
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
