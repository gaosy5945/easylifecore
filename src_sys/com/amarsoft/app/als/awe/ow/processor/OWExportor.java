package com.amarsoft.app.als.awe.ow.processor;
import java.io.OutputStream;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;

/**
 * ��ͳ��OWֱ�ӽ����ݱ��������ݿ⣬ȱ���м�ҵ���߼��Ĵ����������ڽӹ�ԭҵ�����߼���Ĭ�ϲ��ᱣ�������ݿ⣬���д���ת���ⲿҵ���߼�����
 * @author ygwang
 */
public interface OWExportor {
	public int exportFile(OutputStream outputStream,ALSBusinessProcess businessProcess) throws Exception;
}
