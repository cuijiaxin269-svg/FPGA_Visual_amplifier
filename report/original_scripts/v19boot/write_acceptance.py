"""Write human-readable acceptance from completed evidence, before sealing."""
from pathlib import Path
import json
R=Path(__file__).resolve().parents[1]
E=R.parents[1]/'board_checks/20261030_v19boot_01'
f=json.loads((E/'flash_verified.json').read_text(encoding='utf-8'))
assert f['verified']
cfile=E/'cold_boot_verified.json'
c=json.loads(cfile.read_text(encoding='utf-8')) if cfile.exists() else {'verified':False}
cold=('通过：用户实际断电/上电，回读 BOOT_MODE=1（QSPI），DDR/PL 已初始化；\n'
      '只读采样的应用 .text 69,876 字节与本候选 ELF 逐字节相同，运行时间增长，\n'
      '状态 STOPPED，VIEW 2，alpha 12，曝光 320。检查期间没有下载程序、复位或 START。') if c['verified'] else '待完成：尚无实际断电 QSPI 自启动的通过证据。'
text=f'''v19boot 固化验收记录

交付范围
用户要求固化至板载 Flash。当前仅开发板，无 OV9281、HDMI 显示器、串口屏。
保留上电 STOPPED；没有为了裸板验收添加自动 START。

已完成
1. v18hmi 封存输入逐文件哈希验证；原候选未改动。PL 位流原样复用。
2. QSPI0 单片接口平台差异审计；仅允许 QSPI/MIO/对应时钟变更。
3. ARM 应用构建与 HMI 协议、调度、UART 主机测试通过。
4. 官方 FSBL 构建；BOOT.BIN 头校验、三分区、入口与 ELF 载荷比对通过。
5. 调试器辅助 FSBL 交接通过；64 KiB 保留区先填 A5，再验证应用初始化。
   这项交接测试本身不是 BootROM 从 Flash 自启动测试。
6. 原 Flash 全部 16 MiB 备份，经独立第二次读取比对及主机 CRC32 确认。
7. 固化与读回验证通过。镜像 {f['image_bytes']:,} 字节，SHA256：
   {f['image_sha256']}
   板端按 256 字节页比对/恢复：写入 {f['programmed_pages']} 页，已有相同内容跳过 {f['identical_skipped_pages']} 页。
   写入页立即逐字节读回；最后对整个 Flash 镜像计算 CRC32={f['image_crc32']}，与上传镜像一致。
   0x00cb0000..0x00ffffff 尾部 CRC32 前后均为 15890968，与原备份一致。
   最终 SR1=0，Flash 未在写入/擦除，也未保持写使能。

冷启动
{cold}

过程中的失败和处理
两次官方 program_flash 均在主机传输阶段停滞，不能按退出码 0 计为成功。
后续上传遇到 FT_Write / FT_Read USB 传输错误；失败时没有通过完整 DDR 镜像校验，
因此未发出新的 Flash 编程命令。重启自有 JTAG 服务并由用户更换 USB 数据线后，
保留 DDR，从 8,060,928 字节处续传。最终以板端验证记录为准。
恢复写入不执行再次擦除，仅在每个目标位均允许直接编程的检查通过后启动。
首次板端写入在 0x320000 页读回失败：恢复程序误给编程调用传入接收缓冲，
qspips_v3_9 将前 4 数据字节之后的发送内容换成 FF。已改为发送专用的 NULL
接收缓冲；保留完整 DDR 镜像，重新校验并恢复写入，不需重新传输或擦除。

未验证
摄像头采集、HDMI 实际画面、串口屏收发和 START/STOP 联动；重复掉电启动、长时间稳定性。
v18 的历史 32 分钟记录仅为来源证据，不能称为 v19 长稳或 60 分钟通过。
USB 链路故障的根因尚未被独立测定；成功的一轮不等于下载器/线路长期健康认证。

证据与回退
reports/flash_verified.json、reports/cold_boot_verified.json（如有）、reports/board_evidence/。
recovery/flash_before_16MiB.bin 为原始完整备份；恢复方法见 README.txt。
build/candidate/manifest.json 封存各文件哈希；build/v19boot_source_and_candidate.zip 为交付包。
'''
(R/'ACCEPTANCE.txt').write_text(text,encoding='utf-8')
print('V19_ACCEPTANCE_WRITTEN cold_boot_verified='+str(c['verified']))
