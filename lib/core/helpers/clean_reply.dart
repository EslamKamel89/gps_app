String cleanReply(String reply) {
  reply = reply.replaceAll(RegExp(r'【.*?】'), '');
  reply = reply.replaceAll('#', '');
  reply = reply.replaceAll('*', '');

  reply = reply.replaceAll('html```', '');
  reply = reply.replaceAll('```', '');
  reply = reply.replaceAll('html', '');
  reply = reply.replaceAll('<"lang="ar>', '');
  reply = reply.replaceAll('lang="ar"', '');
  reply = reply.replaceAll('< >', '');
  reply = reply.replaceAll('24px', '20px');
  reply = reply.replaceAll('br', 'wrong');
  reply = reply.trim();

  reply = reply.replaceAll('  ', ' ');
  return reply;
}
