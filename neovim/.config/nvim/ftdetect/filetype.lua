vim.filetype.add({
  filename = {
    ['.env'] = 'sh',
    ['.envrc'] = 'sh',
    ['*.env'] = 'sh',
    ['*.envrc'] = 'sh',
    ['env.sample'] = 'sh',
  },
  pattern = {
    ['Dockerfile.*'] = 'dockerfile',
  },
})
