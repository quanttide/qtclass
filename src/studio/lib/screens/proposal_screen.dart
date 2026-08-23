import 'package:flutter/material.dart';

import '../services/learn_api.dart';
import '../services/learner_service.dart';
import 'login_screen.dart';

/// 立项申请表（生产实习第五步·微型创业 Sell Your Demo）。
/// 对齐原型 m5 内嵌表单：5 问 + 方向类型 + 组队方式姓名栏——
/// 个人独立 → 只显示个人姓名；搭档 → 队长姓名 + 队员姓名（顿号分隔）。
class ProposalScreen extends StatefulWidget {
  const ProposalScreen({super.key, this.api});

  final LearnApi? api;

  @override
  State<ProposalScreen> createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen> {
  late LearnApi _api;
  final _name = TextEditingController();
  final _projectName = TextEditingController();
  final _opportunity = TextEditingController();
  final _fit = TextEditingController();
  final _hypothesis = TextEditingController();
  final _demo = TextEditingController();
  String _direction = '内容';
  String _teamMode = 'personal';
  final _leader = TextEditingController();
  final _member = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _api = widget.api ?? LearnApi();
    _initName();
  }

  Future<void> _initName() async {
    _name.text = await LearnerService.name();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _api.submitProposal(
        projectName: _projectName.text.trim(),
        opportunity: _opportunity.text.trim(),
        fit: _fit.text.trim(),
        hypothesis: _hypothesis.text.trim(),
        demo: _demo.text.trim(),
        directionType: _direction,
        teamMode: _teamMode,
        teamLeader: _leader.text.trim(),
        teamMember: _member.text.trim(),
        studentName: _name.text.trim(),
      );
      // 提交后学员身份取表单姓名（组队时=队长姓名）
      final identity = _name.text.trim().isNotEmpty
          ? _name.text.trim()
          : _leader.text.trim();
      await LearnerService.setName(identity);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('立项已提交')));
        Navigator.pop(context);
      }
    } on LearnApiException catch (e) {
      if (e.statusCode == 401 && mounted) {
        await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
        return;
      }
      if (mounted) {
        setState(() => _error = e.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = '提交失败，请检查网络后重试');
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('立项申请')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                '微型创业 · 立项申请',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              const Text(
                '说清楚你发现了什么、为什么适合量潮、两周后想证明什么',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: '你的姓名',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _projectName,
                decoration: const InputDecoration(
                  labelText: '项目名称（便于传播的名字）',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _opportunity,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: '发现的机会（谁遇到什么问题、现有方案哪里不够好）',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _fit,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: '为什么适合量潮（与已有业务/能力/客户的关系）',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _hypothesis,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: '核心假设（如果只能验证一件事，最想证明什么）',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _demo,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: '准备 Sale 什么 Demo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _direction,
                decoration: const InputDecoration(
                  labelText: '方向类型',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: '内容', child: Text('内容')),
                  DropdownMenuItem(value: '数据', child: Text('数据')),
                  DropdownMenuItem(value: '渠道', child: Text('渠道')),
                  DropdownMenuItem(value: '方法', child: Text('方法')),
                ],
                onChanged: (v) => setState(() => _direction = v ?? '内容'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _teamMode,
                decoration: const InputDecoration(
                  labelText: '组队方式',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'personal', child: Text('个人独立')),
                  DropdownMenuItem(value: 'partner', child: Text('已找好搭档')),
                ],
                onChanged: (v) => setState(() => _teamMode = v ?? 'personal'),
              ),
              const SizedBox(height: 12),
              if (_teamMode == 'personal')
                TextField(
                  controller: _leader,
                  decoration: const InputDecoration(
                    labelText: '你的姓名（个人独立）',
                    border: OutlineInputBorder(),
                  ),
                )
              else ...[
                TextField(
                  controller: _leader,
                  decoration: const InputDecoration(
                    labelText: '队长姓名',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _member,
                  decoration: const InputDecoration(
                    labelText: '队员姓名（多个用顿号分隔）',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('提交立项'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
